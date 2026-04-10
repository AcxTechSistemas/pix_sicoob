<a name="readme-top"></a>

<h1 align="center">Pix Sicoob - Easy to use interface for integrating with Sicoob Pix API in your Flutter Apps.</h1>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://pub.dev/packages/pix_sicoob">
    <img src="https://raw.githubusercontent.com/AcxTechSistemas/pix_sicoob/main/images/package-logo.jpeg" alt="Logo" width="600">
  </a>

  <p align="center">
    This package offers an easy-to-use interface for integrating with Sicoob Pix API. With this package, you can get transaction information quickly and efficiently in your Flutter apps.
    <br />
    <a href="https://pub.dev/documentation/pix_sicoob/latest/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <!-- <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a> -->
    <!-- · -->
    <a href="https://github.com/AcxTechSistemas/pix_sicoob/issues">Report Bug</a>
    ·
    <a href="https://github.com/AcxTechSistemas/pix_sicoob/issues">Request Feature</a>
  </p>

<br>

<!--  SHIELDS  ---->

[![License](https://img.shields.io/github/license/AcxTechSistemas/pix_sicoob?style=plastic)](https://github.com/AcxTechSistemas/pix_sicoob/blob/main/LICENSE)
[![Pub Points](https://img.shields.io/pub/points/pix_sicoob?label=pub%20points&style=plastic)](https://pub.dev/packages/pix_sicoob/score)
[![Contributors](https://img.shields.io/github/contributors/AcxTechSistemas/pix_sicoob?style=plastic)](https://github.com/AcxTechSistemas/pix_sicoob/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/AcxTechSistemas/pix_sicoob?color=yellowgreen&logo=github&style=plastic)](https://github.com/AcxTechSistemas/pix_sicoob/graphs/contributors)

[![Pub Publisher](https://img.shields.io/pub/publisher/pix_sicoob?style=plastic)](https://pub.dev/publishers/acxtech.com.br/packages)

</div>
<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#how-to-use">How To Use</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<br>

<!-- ABOUT THE PROJECT -->

## About The Project

<br>
<Center>
<img src="https://raw.githubusercontent.com/AcxTechSistemas/pix_sicoob/main/images/product-screenshot.png" alt="Pix Sicoob PNG" width=500>
</Center>

<br>

This package offers an easy-to-use interface for integrating with Sicoob's Pix API. With this package, you can get transaction information quickly and efficiently in your Flutter apps.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Pre Requirements

- Key Pix registered with Sicoob
- Exclusive for legal entities
- Valid certificate issued by an external CAs complying with the international standard x.509
- Registration on the [Sicoob Developers Portal](https://developers.sicoob.com.br/portal)

## Getting Started

To install This package in your project you can follow the instructions below:

a) Add in your pubspec.yaml:

```sh
 dependencies:
    pix_sicoob: <last-version>
```

b) or use:

```sh
 dart pub add pix_sicoob
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## How To Use

This package is ready for get transactions information quickly!

1. First instantiate the class passing the appropriate parameters
2. Second get the token
3. Third fetch your Pix transactions quickly!

### Instantiate the class

```Dart
final pixSicoob = PixSicoob(
  clientID:'CLIENT_ID',
  certificateBase64String: 'X509_Parsed_TO_BASE64_STRING',
  /*
  This package offer a method to parses file certificate to base64 String
   Method:
    final certBase64String = pixSicoob.certFileToBase64String(
       pkcs12CertificateFile: File('test/cert/cert.pfx'),
       );
  */

  certificatePassword: 'CERTIFICATE_PASSWORD',
);
```

### Get the token

```dart
final token = await pixSicoob.getToken();
```

### Fetch your Pix transactions quickly!

```dart
final listPix = await pixSicoob.fetchTransactions(
  token: token,
);
// Returns the transactions from the last 4 days
```

_For more examples, please refer to the_ [Documentation](https://pub.dev/documentation/pix_sicoob/latest/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FEATURES -->

## Features

- ✅ **Authentication**: Securely retrieve OAuth2 tokens from Sicoob.
- ✅ **Fetch Transactions**: Retrieve Pix transactions within a specified date range.
- ✅ **Certificate Management**: Easily convert X.509 certificates to Base64 strings.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Use cases

### **Convert certificate file to Base64String**

```dart
final certBase64String = pixSicoob.certFileToBase64String(
   pkcs12CertificateFile: File('test/cert/cert.pfx'));
```

### **Request a token**

```dart
final token = await pixSicoob.getToken();
```

### **Fetch Pix Transactions**

- Default Time Range

```dart
final listPix = await pixSicoob.fetchTransactions(
  token: token,
);
//Returns the last 4 days transactions
```

- Custom Time Range

```dart
final listPix = await pixSicoob.fetchTransactions(
  token: token,
  dateTimeRange: DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 360)),
    end: DateTime.now(),
  );
);
//Returns the transactions of the specified date range
```

### **Handling errors**

This package provides structured ways to map and handle different types of errors.
Below are common error keys you might encounter:

- **_the-certificate-password-is-incorrect_**: The certificate password provided is incorrect.
- **_invalid-certificate-file_**: The provided certificate file is invalid.
- **_invalid-certificate-base64string_**: The certificate Base64 string is malformed or invalid.
- **_empty-certificate-password_**: The certificate password cannot be empty.
- **_empty-certificate-base64string_**: The certificate Base64 string cannot be empty.
- **_could-not-find-the-certificate-path_**: The system could not locate the certificate file at the specified path.
- **_client-id-cannot-be-empty_**: The Client ID must be provided.
- **_date-range-must-be-in-the-same-month_**: Filtering is restricted to within the same calendar month.

## Troubleshooting

### Common Issues

1. **Certificate Parsing Errors**:
   - Ensure your `.pfx` or `.p12` certificate is valid and not expired.
   - Double-check the password; it must match the one set when the certificate was exported.
2. **Connectivity Issues**:
   - Ensure your application has internet access and can reach `api.sicoob.com.br`.
   - Verify that your Client ID is correctly registered on the Sicoob Developers Portal.
3. **Authentication Failures**:
   - Confirm that the certificate corresponds to the Client ID used.
   - Ensure you are using the correct production or sandbox URLs (currently defaults to production).

<!-- CONTRIBUTING -->

## Contributing

🚧 [Contributing Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md) - Currently being updated 🚧

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the appropriate tag.
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Remember to include a tag, and to follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and [Semantic Versioning](https://semver.org/) when uploading your commit and/or creating the issue.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the MIT `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Architecture

Check the architecture used in the project `ARCHITECTURE.md`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT
## Contact

AcxTech Sistemas
- [Website](https://www.acxtech.com.br/)
- [Other useful links](https://linktr.ee/acxtech)


<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- ACKNOWLEDGMENTS -->

## Acknowledgements

Thank you to all the people who contributed to this project. Without you, this project would not be here today.

<a href="https://github.com/AcxTechSistemas/pix_sicoob/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=AcxTechSistemas/pix_sicoob" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Maintained by

---

<br>
<p align="center">
  <a href="https://www.acxtech.com.br">
    <img width="110px" src="https://avatars.githubusercontent.com/u/125107060?s=400&u=85fb5cd28beb2bd641234de757e6f6f8c872355c&v=4">
  </a>
  <p align="center">
    Built and maintained by <a href="https://www.acxtech.com.br">AcxTech Sistemas</a>.
  </p>
