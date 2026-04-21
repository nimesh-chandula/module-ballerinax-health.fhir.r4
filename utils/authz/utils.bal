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

# Default practitioner authorization function.
# Denies all practitioner access. Consumers must provide their own implementation
# that validates whether a practitioner is associated with the patient.
#
# + patientId - The patient ID being accessed
# + practitionerId - The practitioner ID from the JWT
# + return - Authorization response (always denied by default)
public isolated function defaultAuthorizePractitioner(string patientId, string practitionerId) returns r4:AuthzResponse {
    log:printWarn("[Authorize Practitioner] No custom practitioner authorization function configured. Denying access. " +
    "Provide an 'authorizePractitioner' function in AuthzConfig to enable practitioner authorization.");
    return {isAuthorized: false};
}

# Default privileged user authorization function.
# Checks the JWT for a privileged claim and validates it is set to "true".
#
# + authzRequest - The FHIR authorization request
# + return - Authorization response
public isolated function defaultAuthorizePrivilegedUser(r4:AuthzRequest & readonly authzRequest) returns r4:AuthzResponse {
    string? privilegedClaimUrl = authzRequest.privilegedClaimUrl;
    if (privilegedClaimUrl is string) {
        anydata|error authenticatedPrivilegedClaim = getClaimValue(privilegedClaimUrl, authzRequest);
        if (authenticatedPrivilegedClaim is string && "true".equalsIgnoreCaseAscii(authenticatedPrivilegedClaim)) {
            return {isAuthorized: true, scope: r4:PRIVILEGED};
        }
        log:printDebug("[Authorize Privileged User] Privileged claim is not set to 'true'.", claim_url = privilegedClaimUrl);
    } else {
        log:printDebug("[Authorize Privileged User] No privilegedClaimUrl set in request.");
    }
    return {isAuthorized: false};
}

# Extract a claim value from the JWT in an authorization request.
# Useful for consumers writing custom authorization logic.
#
# + claimName - The name of the JWT claim to extract
# + payload - The FHIR authorization request containing the JWT
# + return - The claim value, or an error if the claim is not found
public isolated function getClaimValue(string claimName, r4:AuthzRequest payload) returns anydata|error {
    r4:JWT? & readonly jwt = payload.fhirSecurity.jwt;
    if (jwt is r4:JWT && jwt.payload.hasKey(claimName)) {
        log:printDebug("[Get Claim Value] Claim found.", claim_name = claimName);
        return jwt.payload[claimName];
    }
    log:printDebug("[Get Claim Value] Claim not found.", claim_name = claimName);
    return error("Claim not found.");
}
