// Copyright (c) 2025-2026, WSO2 LLC. (http://www.wso2.com).

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

json samplePatient1 = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    },
    "address": [
        {
            "use": "home",
            "line": [
                "534 Erewhon St",
                "sqw"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "country": "Australia"
        },
        {
            "use": "work",
            "line": [
                "33[0] 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ]
};

json samplePatient2 = {
    "resourceType": "Patient",
    "id": "2",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "John",
                "Doe"
            ]
        },
        {
            "use": "usual",
            "given": [
                "John"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1970-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    }
};

json samplePatient3 = {
    "resourceType": "Patient",
    "id": "3",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    },
    "address": [
        {
            "use": "home",
            "line": [
                "11 Main St",
                "ABC Road"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "country": "Australia"
        },
        {
            "use": "work",
            "line": [
                "75346 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ]
};

json sampleOrganization1 = {
    "resourceType": "Organization",
    address: [
        {
            "use": "work",
            "line": [
                "33[0] 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ],
    active: false,
    language: "eng",
    contact: [
        {
            "address": {
                "use": "work",
                "line": [
                    "33[0] 6th St"
                ],
                "city": "Melbourne",
                "district": "Rainbow",
                "state": "Vic",
                "postalCode": "3000",
                "country": "Australia"
            }
        }
    ],
    id: "test_ID",
    name: "test_name"
};

json invalidFhirResource = {
    "resourceType": "Patient",
    "id": "591841",
    "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
    },
    "identifier": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/v2/0203",
                        "code": "MR"
                    }
                ]
            },
            "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
        }
    ],
    "name": [
        {
            "family": "Cushing",
            "given": ["Caleb"]
        }
    ],
    "birthDate": "jdlksjldjl"
};
