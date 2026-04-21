// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerinax/health.fhir.r4;
import ballerina/log;

# Authorize a FHIR request based on cascading patient -> practitioner -> privileged user logic.
#
# + authzRequest - The FHIR authorization request containing JWT and patient context
# + config - Authorization configuration with claim names and custom authorization functions
# + return - Authorization response with `isAuthorized` status and scope
public isolated function authorize(r4:AuthzRequest & readonly authzRequest, AuthzConfig & readonly config = {}) returns r4:AuthzResponse {
    // Input validation
    r4:FHIRSecurity fhirSecurity = authzRequest.fhirSecurity;
    if (!fhirSecurity.securedAPICall) {
        log:printWarn("[Authorize] Request is not a secured API call. Denying access.");
        return {isAuthorized: false};
    }
    if (fhirSecurity.jwt is ()) {
        log:printWarn("[Authorize] No JWT present in request. Denying access.");
        return {isAuthorized: false};
    }

    AuthorizePrivilegedUserFunction authorizePrivilegedUserFn = config.authorizePrivilegedUser;
    AuthorizePractitionerFunction authorizePractitionerFn = config.authorizePractitioner;

    string? pid = authzRequest.patientId;
    if (pid is ()) {
        log:printInfo("[Authorize] Bulk data access request. Checking privileged user authorization.");
        r4:AuthzResponse response = authorizePrivilegedUserFn(authzRequest);
        log:printInfo("[Authorize] Bulk data access decision.", isAuthorized = response.isAuthorized);
        return response;
    }

    if (pid == "") {
        log:printWarn("[Authorize] Empty patientId in request. Denying access.");
        return {isAuthorized: false};
    }

    log:printInfo("[Authorize] Single patient data access request.");
    log:printDebug("[Authorize] Single patient data access request.", patient_id = pid);

    // Check 1: Patient
    anydata|error authenticatedPatientId = getClaimValue(config.patientIdClaim, authzRequest);
    if (authenticatedPatientId is string) {
        if (pid == authenticatedPatientId) {
            log:printInfo("[Authorize] Authorized as patient.");
            log:printDebug("[Authorize] Authorized as patient.", patient_id = pid);
            return {isAuthorized: true, scope: r4:PATIENT};
        }
        log:printInfo("[Authorize] Patient claim present but does not match requested patient.");
        log:printDebug("[Authorize] Patient claim present but does not match requested patient.",
        requested_patient_id = pid, authenticated_patient_id = authenticatedPatientId);
        // A patient can also be a practitioner or privileged user, so continue checking
    }

    // Check 2: Practitioner
    anydata|error authenticatedPractitionerId = getClaimValue(config.practitionerIdClaim, authzRequest);
    if (authenticatedPractitionerId is string) {
        if (authorizePractitionerFn(pid, authenticatedPractitionerId).isAuthorized) {
            log:printInfo("[Authorize] Authorized as practitioner.");
            log:printDebug("[Authorize] Authorized as practitioner.", practitioner_id = authenticatedPractitionerId, patient_id = pid);
            return {isAuthorized: true, scope: r4:PRACTITIONER};
        }
        log:printInfo("[Authorize] Practitioner claim present but not authorized for patient.");
        log:printDebug("[Authorize] Practitioner claim present but not authorized for patient.",
        practitioner_id = authenticatedPractitionerId, patient_id = pid);
    }

    // Check 3: Privileged user
    r4:AuthzResponse response = authorizePrivilegedUserFn(authzRequest);
    if (response.isAuthorized) {
        log:printInfo("[Authorize] Authorized as privileged user.");
    } else {
        log:printWarn("[Authorize] Access denied. No matching role found.");
    }
    return response;
}
