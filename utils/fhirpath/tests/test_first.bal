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
public function testFirstFunction() returns error? {
    // first() on a multi-element collection should return the first element
    json[]|error result = getValuesFromFhirPath(samplePatient1, "Patient.name.first()");
    if result is json[] {
        test:assertEquals(result.length(), 1, msg = "first() should return exactly one element!");
        json firstItem = result[0];
        test:assertTrue(firstItem is map<json>, msg = "first() result should be a JSON object!");
        test:assertEquals((<map<json>>firstItem)["use"], "official", msg = "first() should return the first name entry!");
    } else {
        test:assertFail(msg = "Expected success but got error");
    }

    // first() on addresses
    result = getValuesFromFhirPath(samplePatient1, "Patient.address.first()");
    if result is json[] {
        test:assertEquals(result.length(), 1, msg = "first() should return exactly one element!");
        json firstItem = result[0];
        test:assertTrue(firstItem is map<json>, msg = "first() result should be a JSON object!");
        test:assertEquals((<map<json>>firstItem)["city"], "PleasantVille", msg = "first() should return the first address!");
    } else {
        test:assertFail(msg = "Expected success but got error");
    }

    // first() on a single-element collection should return that element
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.id.first()"), ["1"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.active.first()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.gender.first()"), ["male"], msg = "Failed!");

    // first() on array elements accessed via path
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.given.first()"), ["Peter"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.use.first()"), ["home"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.city.first()"), ["PleasantVille"], msg = "Failed!");

    // first() on empty/non-existent paths should return empty collection
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.mor.first()"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.meta.profile[8].first()"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "Patient.address.first()"), [], msg = "Failed!");
}

@test:Config {}
public function testFirstFunctionWithoutResourceType() returns error? {
    // first() without resource type prefix
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.given.first()"), ["Peter"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.city.first()"), ["PleasantVille"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.mor.first()"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "address.first()"), [], msg = "Failed!");
}

@test:Config {}
public function testFirstFunctionChainedWithWhere() returns error? {
    // first() chained after where() with matches
    json[]|error result = getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official').first()");
    if result is json[] {
        test:assertEquals(result.length(), 1, msg = "first() should return exactly one element!");
        json firstItem = result[0];
        test:assertTrue(firstItem is map<json>, msg = "first() result should be a JSON object!");
        test:assertEquals((<map<json>>firstItem)["use"], "official", msg = "Failed!");
    } else {
        test:assertFail(msg = "Expected success but got error");
    }

    // first() chained after where() with no matches should return empty
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'nickname').first()"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Sydney').first()"), [], msg = "Failed!");
}

@test:Config {}
public function testFirstFunctionChainedWithExists() returns error? {
    // first() chained with exists() - should return true when first element exists
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.first().exists()"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.first().exists()"), [true], msg = "Failed!");

    // first() chained with empty() - should return false when first element exists
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.first().empty()"), [false], msg = "Failed!");

    // first() on empty collection chained with exists() should return false
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "Patient.address.first().exists()"), [false], msg = "Failed!");

    // first() on empty collection chained with empty() should return true
    test:assertEquals(getValuesFromFhirPath(samplePatient2, "Patient.address.first().empty()"), [true], msg = "Failed!");
}
