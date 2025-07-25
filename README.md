# Continuous Integration with GitHub Actions

## Overview

This project demonstrates the implementation of Continuous Integration (CI) using GitHub Actions. The tasks carried out in this project align with the requirements of Module 3: Implementing Continuous Integration.

By mastering continuous integration with GitHub Actions, you are not just learning to code; you are learning to build your software efficiently, piece by piece, ensuring quality and cohesion at every step.

## Pre-requisites

### 1. Proficiency in YAML (Refer to Project 2):
- Basic understanding of YAML syntax and structure.
- Familiarity with writing and interpreting YAML files, as GitHub Actions workflows are defined in YAML.

Resource: Learn YAML in Y Minutes

### 2. Experience with GitHub and Github Actions:
- Basic knowledge of how to use GitHub, including creating repositories and pushing code.
- A foundational understanding of GitHub Actions and how they work.

Resource: GitHub Actions Documentation

### 3. Understanding of Node.js and npm:
- Experience with Node.js, as the project examples are based on Node.js environments.
- Familiarity with npm (Node Package Manager) for managing Node.js project dependencies.

Resource: Node.js Documentation

### 4. Familiarity with Software Testing Concepts:
- Basic knowledge of software testing principles.
- Understanding of automated testing and its role in CI/CD.

### 5. Knowledge of Code Quality Tools:
- Familiarity with static code analysis and linting tools, especially ESLint for JavaScript.

### 6. Access to a Development Environment:

- A computer with Git, Node.js, and a text editor or IDE installed.
- Internet access to clone the project repository and perform tasks online.

### 7. Willingness to Experiment and Learn:

- An open-minded approach to learning new CI/CD practices.
- Eagerness to apply new concepts and troubleshoot potential issues.

By fulfilling these prerequisites, learners will be well-prepared to dive into the lessons on configuring build matrices and integrating code quality checks, gaining hands-on experience in implementing continuous integration workflows with GitHub Actions.

## Task

### 1. Configure Build Matrices for Testing Across Multiple Environments
We created a GitHub Actions workflow using the `matrix` strategy to test across multiple Node.js versions (12.x, 14.x, and 16.x). This allows us to ensure compatibility with different versions of Node.js.

```yaml
strategy:
  matrix:
    node-version: [12.x, 14.x, 16.x]
```

### 2. Manage Build Dependencies Efficiently
We used the `actions/cache@v2` action to cache `node_modules` using the hash of the `package-lock.json` file. This speeds up the workflow by skipping repeated dependency installations.

```yaml
- name: Cache Node Modules
  uses: actions/cache@v2
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

### 3. Integrate Code Analysis Tools into Workflow
We added ESLint to the workflow to run static code analysis and maintain code quality.

```yaml
- name: Run Linter
  run: npx eslint .
```

### 4. Configure Linters and Static Code Analyzers
We ensured the repository has a `.eslintrc` configuration file defining linting rules.

Example `.eslintrc`:

```json
{
  "env": { "browser": true, "es6": true },
  "extends": ["eslint:recommended"],
  "rules": { "no-console": "warn" }
}
```
## Conclusion

By implementing matrix builds, caching dependencies, and integrating code quality checks, this project sets up a robust CI pipeline using GitHub Actions.