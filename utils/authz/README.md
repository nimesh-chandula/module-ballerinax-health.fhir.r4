# FHIR R4 Authorization Library

A reusable Ballerina library that provides role-based access control for FHIR R4 APIs. It evaluates whether a user is authorized to access patient data based on their role: **Patient**, **Practitioner**, or **Privileged User**.

## Authorization Flow

The library uses a cascading authorization check:

1. **Patient** - Is the user a patient accessing their own data? (JWT claim must match the requested `patientId`)
2. **Practitioner** - Is the user a practitioner associated with the patient? (customizable logic)
3. **Privileged User** - Does the user have a privileged claim set to `true`? (checks JWT)

If no `patientId` is provided in the request (bulk data access), only privileged user authorization is checked.

## Installation

### From Local Repository

```bash
cd authz-fhirr4
bal pack
bal push --repository=local
```

Then add the dependency in your project's `Ballerina.toml`:

```toml
[[dependency]]
org = "wso2"
name = "health.fhir.r4.authz"
version = "1.0.0"
repository = "local"
```

## Usage

### Basic Usage (Default Configuration)

```ballerina
import wso2/health.fhir.r4.authz;
import ballerinax/health.fhir.r4;

r4:AuthzResponse response = authz:authorize(authzRequest);
```

With default configuration:
- Patient ID is read from the `"patient"` JWT claim
- Practitioner ID is read from the `"practitioner"` JWT claim
- Practitioner authorization denies all requests (you must provide your own logic)
- Privileged user authorization checks the JWT claim specified in `privilegedClaimUrl`

### Custom Configuration

```ballerina
import wso2/health.fhir.r4.authz;
import ballerinax/health.fhir.r4;

authz:AuthzConfig config = {
    patientIdClaim: "sub",
    practitionerIdClaim: "doctor_id",
    authorizePractitioner: myPractitionerAuthFn,
    authorizePrivilegedUser: myPrivilegedUserAuthFn
};

r4:AuthzResponse response = authz:authorize(authzRequest, config);
```

### Custom Practitioner Authorization

The default practitioner authorization denies all requests. You should provide your own implementation that checks whether a practitioner is associated with the patient (e.g., via a database lookup).

```ballerina
isolated function myPractitionerAuthFn(string patientId, string practitionerId) returns r4:AuthzResponse {
    // Example: check a database to see if the practitioner is associated with the patient
    boolean isAssociated = check db->queryRow(
        `SELECT COUNT(*) > 0 FROM patient_practitioner 
         WHERE patient_id = ${patientId} AND practitioner_id = ${practitionerId}`
    );
    if (isAssociated) {
        return {isAuthorized: true, scope: r4:PRACTITIONER};
    }
    return {isAuthorized: false};
}
```

### Custom Privileged User Authorization

The default implementation checks the JWT for a claim (specified by `privilegedClaimUrl` in the request) set to `"true"`. You can override this with your own logic.

```ballerina
isolated function myPrivilegedUserAuthFn(r4:AuthzRequest & readonly authzRequest) returns r4:AuthzResponse {
    // Example: check for a specific role claim
    anydata|error role = authz:getClaimValue("http://example.org/claims/role", authzRequest);
    if (role is string && role == "admin") {
        return {isAuthorized: true, scope: r4:PRIVILEGED};
    }
    return {isAuthorized: false};
}
```

## API Reference

### Functions

| Function | Description |
|---|---|
| `authorize(r4:AuthzRequest & readonly authzRequest, AuthzConfig config = {}) returns r4:AuthzResponse` | Main authorization function with cascading role checks |
| `getClaimValue(string claimName, r4:AuthzRequest payload) returns anydata\|error` | Extract a JWT claim value from an authorization request |
| `defaultAuthorizePrivilegedUser(r4:AuthzRequest & readonly authzRequest) returns r4:AuthzResponse` | Default privileged user check (validates JWT privileged claim) |
| `defaultAuthorizePractitioner(string patientId, string practitionerId) returns r4:AuthzResponse` | Default practitioner check (denies all — override with your own) |

### Types

| Type | Description |
|---|---|
| `AuthzConfig` | Configuration record with claim names and custom authorization functions |
| `AuthorizePractitionerFunction` | Function type for custom practitioner authorization logic |
| `AuthorizePrivilegedUserFunction` | Function type for custom privileged user authorization logic |

### AuthzConfig Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `patientIdClaim` | `string` | `"patient"` | JWT claim name for patient ID |
| `practitionerIdClaim` | `string` | `"practitioner"` | JWT claim name for practitioner ID |
| `authorizePractitioner` | `AuthorizePractitionerFunction` | `defaultAuthorizePractitioner` | Custom practitioner authorization function |
| `authorizePrivilegedUser` | `AuthorizePrivilegedUserFunction` | `defaultAuthorizePrivilegedUser` | Custom privileged user authorization function |
