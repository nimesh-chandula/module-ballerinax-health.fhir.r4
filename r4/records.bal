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

# Analytics event parameters for the claim response in prior authorization flow
# 
# + claimType - The type of the claim (standard or expedited)
# + claimStatus - The status of the claim (approved or denied)
# + timeToDecide - The time taken to make a decision on the claim in hours
# + isSLAViolated - Whether the decision time violated the SLA
public type PriorAuthorisationAnalyticsResponseEvent readonly & record {|
    int claimType?;
    int claimStatus?;
    int timeToDecide?;
    boolean isSLAViolated?;
|};