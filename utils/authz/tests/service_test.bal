import ballerina/test;
import ballerinax/health.fhir.r4;

// Test functions
@test:Config {}
function testAuthorizingWithAPatient() {
    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "patient": "123",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PATIENT});
}

@test:Config {}
function testAuthorizingWithAPrivilegedUser() {
    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "privileged": "true",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PRIVILEGED});
}

@test:Config {}
function testAuthorizingWithAPrivilegedUserForAllPatientData() {
    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "http://abc.org/claims/privileged": "true",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        privilegedClaimUrl: "http://abc.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PRIVILEGED});
}

// Negative test function
@test:Config {}
function testAuthorizingWithADifferentPatient() {
    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "patient": "1234",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest);
    test:assertEquals(response, {isAuthorized: false});
}

@test:Config {}
function testAuthorizingWithAnUnprivilegedUser() {
    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest);
    test:assertEquals(response, {isAuthorized: false});

    r4:AuthzRequest & readonly authzRequest2 = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "http://wso2.org/claims/privileged": "false",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response2 = authorize(authzRequest2);
    test:assertEquals(response2, {isAuthorized: false});
}

@test:Config {}
function testAuthorizingWithAnUnprivilegedUserForAllPatientData() {
    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "patient": "1234",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest);
    test:assertEquals(response, {isAuthorized: false});
}

// Test with custom practitioner authorization function
@test:Config {}
function testAuthorizingWithCustomPractitionerFunction() {
    AuthorizePractitionerFunction customAuthzPractitioner = isolated function(string patientId, string practitionerId) returns r4:AuthzResponse {
        // Allow practitioner "doc1" to access patient "123"
        if (practitionerId == "doc1" && patientId == "123") {
            return {isAuthorized: true, scope: r4:PRACTITIONER};
        }
        return {isAuthorized: false};
    };

    AuthzConfig & readonly config = {
        authorizePractitioner: customAuthzPractitioner
    };

    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "practitioner": "doc1",
                    "http://wso2.org/claims/apiname": "PatientApi"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest, config);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PRACTITIONER});
}

// Test with custom claim names
@test:Config {}
function testAuthorizingWithCustomClaimNames() {
    AuthzConfig & readonly config = {
        patientIdClaim: "sub"
    };

    r4:AuthzRequest & readonly authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "sub": "patient-456",
                    "http://wso2.org/claims/apiname": "PatientApi"
                }
            }
        },
        "patientId": "patient-456",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse response = authorize(authzRequest, config);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PATIENT});
}
