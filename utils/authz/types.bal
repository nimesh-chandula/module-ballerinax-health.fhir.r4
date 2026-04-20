// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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

# Function type for customizing practitioner authorization logic.
# Implement this to define how practitioners are authorized to access patient data.
#
# + patientId - The patient ID being accessed
# + practitionerId - The practitioner ID from the JWT
# + return - Authorization response indicating whether the practitioner is authorized
public type AuthorizePractitionerFunction isolated function (string patientId, string practitionerId) returns r4:AuthzResponse;

# Function type for customizing privileged user authorization logic.
# Implement this to define how privileged users are authorized.
#
# + authzRequest - The FHIR authorization request
# + return - Authorization response indicating whether the user is authorized
public type AuthorizePrivilegedUserFunction isolated function (r4:AuthzRequest & readonly authzRequest) returns r4:AuthzResponse;

# Configuration for the FHIR authorization handler.
#
# + patientIdClaim - JWT claim name for patient ID (default: "patient")
# + practitionerIdClaim - JWT claim name for practitioner ID (default: "practitioner")
# + authorizePractitioner - Custom function for practitioner authorization (default: deny all)
# + authorizePrivilegedUser - Custom function for privileged user authorization (default: checks JWT privileged claim)
public type AuthzConfig record {|
    string patientIdClaim = "patient";
    string practitionerIdClaim = "practitioner";
    AuthorizePractitionerFunction authorizePractitioner = defaultAuthorizePractitioner;
    AuthorizePrivilegedUserFunction authorizePrivilegedUser = defaultAuthorizePrivilegedUser;
|};
