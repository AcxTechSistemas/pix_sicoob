# Pix Sicoob Example

This example demonstrates how to integrate the `pix_sicoob` package into a Flutter application. It showcases authentication, transaction fetching, and certificate handling.

## Configuration

To run the example, you need to provide your own Sicoob credentials and certificate.

1.  **Configure Credentials**:
    Edit the `example/assets/config.json` file with your details:
    ```json
    {
      "clientID": "YOUR_CLIENT_ID",
      "certificatePassword": "YOUR_CERTIFICATE_PASSWORD",
      "certificatePath": "assets/certs/your_certificate.pfx"
    }
    ```

2.  **Add your Certificate**:
    Place your `.pfx` or `.p12` certificate in the `example/assets/certs/` directory (create the directory if it doesn't exist).

3.  **Update Pubspec**:
    Ensure your certificate is included in the assets section of `example/pubspec.yaml`.

## Running the Example

Once configured, you can run the example using:

```sh
flutter run
```

## Features Demonstrated

- **Authentication**: Using a Client ID and a PFX certificate to obtain an OAuth2 token.
- **Transaction History**: Fetching the last 4 days of Pix transactions.
- **Error Handling**: Displaying user-friendly messages for common Sicoob API errors.
- **Security**: The example shows how to load sensitive configuration from a JSON file (standard practice in real-world apps).
