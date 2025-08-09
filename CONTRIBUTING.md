# Contributing to SocialForge Protocol

We welcome contributions from the community! This document provides guidelines for contributing to the SocialForge Protocol project.

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. Please treat all community members with respect and create a welcoming environment for everyone.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/social-forge.git
   cd social-forge
   ```
3. **Install dependencies**:
   ```bash
   npm install
   ```
4. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🧪 Development Workflow

### Prerequisites

- Node.js v18 or higher
- Clarinet CLI v2.0+
- Git for version control

### Running Tests

Before submitting any changes, ensure all tests pass:

```bash
# Run all tests
npm test

# Run tests with coverage report
npm run test:report

# Run tests in watch mode during development
npm run test:watch
```

### Code Quality

We maintain high code quality standards:

```bash
# Format Clarity contracts
clarinet fmt --in-place

# Check contracts for errors
clarinet check

# Validate contract syntax
clarinet console
```

## 📝 Contribution Types

### Bug Reports

When reporting bugs, please include:

- **Clear description** of the issue
- **Steps to reproduce** the bug
- **Expected vs actual behavior**
- **Environment details** (OS, Node version, Clarinet version)
- **Relevant logs** or error messages

### Feature Requests

For new features, please provide:

- **Clear description** of the proposed feature
- **Use case** and business justification
- **Implementation approach** (if you have ideas)
- **Potential impact** on existing functionality

### Code Contributions

#### Clarity Smart Contract Guidelines

1. **Follow existing patterns** in the codebase
2. **Use meaningful variable names** and comments
3. **Include comprehensive error handling**
4. **Write accompanying tests** for all new functions
5. **Update documentation** as needed

#### Naming Conventions

```clarity
;; Constants: UPPER_SNAKE_CASE
(define-constant MAX-REPUTATION-SCORE u10000)

;; Functions: kebab-case
(define-public (mint-reputation-certificate))

;; Variables: kebab-case
(define-data-var contract-paused bool false)

;; Maps: kebab-case
(define-map user-profiles principal {...})
```

#### Error Handling

Always use explicit error constants:

```clarity
;; Define specific error constants
(define-constant ERR-INVALID-AMOUNT (err u104))

;; Use in functions
(asserts! (>= amount MIN-TIP-AMOUNT) ERR-INVALID-AMOUNT)
```

#### Testing Requirements

All new functions must include tests:

```typescript
// Example test structure
describe("SocialForge Protocol", () => {
  it("should handle tip creation correctly", () => {
    // Test implementation
  });
  
  it("should enforce minimum tip amounts", () => {
    // Error case testing
  });
});
```

## 🔄 Pull Request Process

### Before Submitting

1. **Ensure all tests pass**: `npm test`
2. **Format your code**: `clarinet fmt --in-place`
3. **Update documentation** if needed
4. **Write descriptive commit messages**

### Pull Request Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings or errors
```

### Review Process

1. **Automated checks** must pass (tests, linting)
2. **Code review** by maintainers
3. **Testing** on testnet (for significant changes)
4. **Final approval** and merge

## 📚 Development Resources

### Clarity Language

- [Clarity Language Reference](https://docs.stacks.co/clarity/)
- [Clarity Functions Guide](https://docs.stacks.co/clarity/functions)
- [Best Practices](https://docs.stacks.co/clarity/best-practices)

### Testing Framework

- [Vitest Documentation](https://vitest.dev/)
- [Clarinet SDK](https://docs.hiro.so/clarinet/js-sdk)

### Stacks Ecosystem

- [Stacks Documentation](https://docs.stacks.co/)
- [Stacks Community](https://stacks.org/community)

## 🐛 Issue Labels

We use labels to categorize issues:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `security` - Security-related issues

## 🔒 Security

If you discover a security vulnerability, please:

1. **Do NOT** create a public issue
2. **Email** the maintainers directly
3. **Provide** detailed information about the vulnerability
4. **Wait** for confirmation before public disclosure

## 📞 Getting Help

Need help or have questions?

- **GitHub Discussions** - For general questions
- **GitHub Issues** - For bug reports and feature requests
- **Discord** - For real-time community support

## 🏆 Recognition

Contributors who make significant improvements will be:

- **Listed** in the project contributors
- **Acknowledged** in release notes
- **Invited** to join the core contributor team (for ongoing contributors)

## 📄 License

By contributing to SocialForge Protocol, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to SocialForge Protocol! 🚀
