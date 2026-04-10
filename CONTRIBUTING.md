# Contributing to Pix Sicoob

First of all, thank you for considering contributing to `pix_sicoob`! It's people like you that make the open-source community a great place.

## How to Contribute

### 1. Code Style and Architecture
This project follows **Clean Architecture** and **SOLID** principles. When adding new features:
- Ensure business logic is separated from infrastructure.
- Use the **Repository Pattern** for data access.
- Depend on abstractions, not concretions (Dependency Inversion).
- Ensure your changes follow the existing project structure (check `ARCHITECTURE.md`).

### 2. Testing
We strive for a high level of test coverage (minimum 70%).
- Write unit tests for all new repositories and services.
- Use `mocktail` for mocking dependencies.
- Ensure all tests pass before submitting a PR:
  ```sh
  flutter test
  ```

### 3. Conventional Commits
We follow [Conventional Commits](https://www.conventionalcommits.org/). Please use descriptive commit messages:
- `feat: ...` for new features
- `fix: ...` for bug fixes
- `docs: ...` for documentation changes
- `chore: ...` for maintenance

### 4. Pull Request Process
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'feat: add some amazing feature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## Reporting Bugs
If you find a bug, please open an issue and include:
- A clear description of the issue.
- Steps to reproduce.
- Expected vs. actual behavior.
- Version of the package and Flutter.

## Suggesting Features
Suggestions are always welcome! Open an issue with the "feature request" tag and describe your idea.
