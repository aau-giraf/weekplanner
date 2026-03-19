# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed
- Upgraded backend from .NET 8 to .NET 10 LTS (EOL Nov 2029)
- Replaced Swashbuckle with built-in OpenAPI + Scalar UI (API docs now at `/scalar/v1`)
- Bumped all NuGet packages to latest (EF Core 10, xunit 2.9, FluentAssertions 7.2)
- Removed unused `MinimalApis.Extensions` dependency
