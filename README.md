# Advanced GitHub Actions CI/CD Course

## Overview

This guide provides a comprehensive summary of the tasks performed while completing the Advanced GitHub Actions CI/CD course. It covers workflow best practices, performance optimizations, security implementations, and error-handling techniques, with real YAML examples and practical explanations.

---

## Lesson 1: Best Practices for Maintainable Workflows

***Objectives**
- Understand how to write maintainable GitHub Action Workfolws.
- Learn about code organization and creating modular workflows.

### Writing Clean Workflows

- **Descriptive Naming**
    ```yaml
    name: Build and Test Application
    jobs:
      build:
        name: Compile Source Code
    ```

- **Documentation in Steps**
    ```yaml
    steps:
      # Install dependencies before building
      - name: Install packages
        run: npm install
    ```

### Modular Workflow Design

- **Reusable Workflows**
    ```yaml
    jobs:
      build:
        uses: ./.github/workflows/build.yml@main
    ```

- **Shared Actions for Efficiency**
    ```yaml
    - uses: actions/cache@v3
      with:
        path: node_modules
        key: ${{ runner.os }}-npm-${{ hashFiles('package-lock.json') }}
    ```

---

## Lesson 2: Performance Optimization

**Objectives**
-  Optimize the execution time of workflows.
- Implement caching to speed up builds.

### Parallel Job Execution

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]
  
  test:
    needs: lint
    runs-on: ubuntu-latest
    steps: [...]

  build:
    needs: test
    runs-on: ubuntu-latest
    steps: [...]
```

### Dependency Caching

```yaml
- uses: actions/cache@v3
  with:
    path: |
      ~/.npm
      ~/.cache
    key: ${{ runner.os }}-node-${{ hashFiles('package-lock.json') }}
```

---

## Lesson 3: Security Best Practices

**Objectives**
- Implement security best practices in the GitHub Actions.
- Secure secrets and sensitive information.

### Principle of Least Privilege

- **Minimal Permissions**
    ```yaml
    permissions:
      contents: read
      packages: write
    ```

### Secret Management

- **Use of GitHub Secrets**
    ```yaml
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    ```

- **Avoid Hardcoding Sensitive Information**
    ```yaml
    run: |
      aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE
    ```  

### Additional Security Measures
- **Secret Rotation:** Update tokens quarterly
- **Workflow Audits:** Review action logs weekly
- **Dependency Scanning:** Use actions/dependency-review-action
---

## Lesson 4: Error Handling

### Workflow Debugging

- **Step-Level Debugging**
    ```yaml
    - name: Debug Output
      run: echo "Current branch: ${{ github.ref }}"
    ```

- **Failure Tolerance**
    ```yaml
    - name: Run Tests
      continue-on-error: true
    ```

### Conditional Execution

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    if: ${{ !contains(github.event.head_commit.message, '[skip ci]') }}
```

---

## Key Takeaways

**Maintainability**
- Use descriptive job/step names
- Document each step with purpose
- Modularize and reuse workflow components

**Performance**
- Use parallel job execution
- Aggressively cache dependencies

**Security**
- Follow least privilege principles
- Never hardcode secrets; use GitHub Secrets
- Schedule regular secret rotation

**Reliability**
- Implement robust error handling
- Use conditional deployment logic
- Monitor workflow duration and failures

---

## Implementation Checklist

- [x] Converted workflows to use reusable actions
- [x] Implemented dependency caching with `actions/cache`
- [x] Reviewed and minimized job permissions
- [x] Set a secret rotation reminder/schedule
- [x] Created templates for common workflows (build, test, deploy)

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Security Best Practices](https://docs.github.com/en/actions/security-guides)
- [Dependency Review Action](https://github.com/actions/dependency-review-action)