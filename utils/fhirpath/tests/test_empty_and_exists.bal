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

import ballerina/test;

@test:Config {}
public function testEmptyFunction() returns error? {
    // empty() on non-empty collections should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.id.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.active.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address[0].line.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.meta.profile.empty()"), [false], msg = "Failed!");

    // empty() on empty/non-existent paths should return true
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.mor.empty()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.meta.profile[8].empty()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "Patient.address.empty()"), [true], msg = "Failed!");

    // empty() chained after where() with no matches should return true
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'nickname').empty()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Sydney').empty()"), [true], msg = "Failed!");

    // empty() chained after where() with matches should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official').empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home').empty()"), [false], msg = "Failed!");
}

@test:Config {}
public function testEmptyFunctionWithoutResourceType() returns error? {
    // empty() without resource type prefix
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.empty()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.mor.empty()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "address.empty()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.where(use = 'nickname').empty()"), [true], msg = "Failed!");
}

@test:Config {}
public function testExistsFunction() returns error? {
    // exists() on non-empty collections should return true
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.id.exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.active.exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address[0].line.exists()"), [true], msg = "Failed!");

    // exists() on empty/non-existent paths should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.mor.exists()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.meta.profile[8].exists()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "Patient.address.exists()"), [false], msg = "Failed!");

    // exists() chained after where() with matches should return true
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official').exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home').exists()"), [true], msg = "Failed!");

    // exists() chained after where() with no matches should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'nickname').exists()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Sydney').exists()"), [false], msg = "Failed!");
}

@test:Config {}
public function testExistsFunctionWithCriteria() returns error? {
    // exists() with criteria that matches should return true
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.exists(use = 'official')"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.exists(use = 'usual')"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.exists(city = 'Melbourne')"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.exists(use = 'home')"), [true], msg = "Failed!");

    // exists() with criteria that doesn't match should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.exists(use = 'nickname')"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.exists(city = 'Sydney')"), [false], msg = "Failed!");

    // exists() with criteria on empty collection should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "Patient.address.exists(use = 'home')"), [false], msg = "Failed!");
}

@test:Config {}
public function testExistsFunctionWithoutResourceType() returns error? {
    // exists() without resource type prefix
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.mor.exists()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "address.exists()"), [false], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.exists(use = 'official')"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.exists(use = 'nickname')"), [false], msg = "Failed!");
}

@test:Config {}
public function testEmptyAndExistsAreOpposites() returns error? {
    // Verify that empty() and exists() return opposite results for the same paths
    json[]|error emptyResult = getValuesFromFhirPath(samplePatient1, "Patient.name.empty()");
    json[]|error existsResult = getValuesFromFhirPath(samplePatient1, "Patient.name.exists()");
    if emptyResult is json[] && existsResult is json[] {
        test:assertEquals(emptyResult[0], !(check existsResult[0].ensureType(boolean)), msg = "empty() and exists() should be opposites!");
    }

    emptyResult = getValuesFromFhirPath(samplePatient2, "Patient.address.empty()");
    existsResult = getValuesFromFhirPath(samplePatient2, "Patient.address.exists()");
    if emptyResult is json[] && existsResult is json[] {
        test:assertEquals(emptyResult[0], !(check existsResult[0].ensureType(boolean)), msg = "empty() and exists() should be opposites!");
    }
}
