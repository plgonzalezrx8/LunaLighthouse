import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const workflowPath = '../.github/workflows/self_hosted_runner_test.yml';

  late String content;

  setUpAll(() {
    final file = File(workflowPath);
    expect(
      file.existsSync(),
      isTrue,
      reason: 'Workflow file must exist at $workflowPath',
    );
    content = file.readAsStringSync();
  });

  group('workflow metadata', () {
    test('has the correct workflow name', () {
      expect(content, contains("name: Self-hosted Runner Test"));
    });

    test('triggers on workflow_dispatch', () {
      expect(content, contains('workflow_dispatch'));
    });

    test('triggers on push to the ci/use-lunalighthouse-runner branch', () {
      expect(content, contains('- ci/use-lunalighthouse-runner'));
    });

    test('does NOT trigger on push to master or main', () {
      // The branch list must not accidentally include master or main so this
      // smoke-test workflow stays scoped to its own integration branch.
      final branchLines = RegExp(r'^\s+-\s+(master|main)\s*$', multiLine: true);
      expect(
        branchLines.hasMatch(content),
        isFalse,
        reason: 'Workflow should not trigger on master or main',
      );
    });

    test('restricts permissions to contents: read only', () {
      expect(content, contains('permissions:'));
      expect(content, contains('contents: read'));
    });
  });

  group('job configuration', () {
    test('defines the Linux runner smoke-test job', () {
      expect(content, contains('linux-runner-smoke-test:'));
    });

    test('defines the macOS runner smoke-test job', () {
      expect(content, contains('macos-runner-smoke-test:'));
    });

    test('Linux job display name is linux-runner-smoke-test', () {
      expect(content, contains('name: linux-runner-smoke-test'));
    });

    test('macOS job display name is macos-runner-smoke-test', () {
      expect(content, contains('name: macos-runner-smoke-test'));
    });

    test('job targets the self-hosted runner label', () {
      expect(content, contains('self-hosted'));
    });

    test('job targets the lunalighthouse runner label', () {
      expect(content, contains('lunalighthouse'));
    });

    test('Linux runs-on includes self-hosted, lunalighthouse, and Linux', () {
      // The labels must appear together on the same runs-on line so the job
      // is routed to the correct custom runner.
      final runsOn =
          RegExp(r'runs-on:\s*\[self-hosted,\s*lunalighthouse,\s*Linux\]');
      expect(
        runsOn.hasMatch(content),
        isTrue,
        reason:
            'Linux runs-on must list self-hosted, lunalighthouse, and Linux',
      );
    });

    test('macOS runs-on includes self-hosted, lunalighthouse, and macOS', () {
      final runsOn =
          RegExp(r'runs-on:\s*\[self-hosted,\s*lunalighthouse,\s*macOS\]');
      expect(
        runsOn.hasMatch(content),
        isTrue,
        reason:
            'macOS runs-on must list self-hosted, lunalighthouse, and macOS',
      );
    });
  });

  group('Checkout Repository step', () {
    test('includes a checkout step', () {
      expect(content, contains('Checkout Repository'));
    });

    test('uses actions/checkout@v4', () {
      expect(content, contains('uses: actions/checkout@v4'));
    });
  });

  group('Verify Runner Host step', () {
    test('includes the Linux Verify Runner Host step', () {
      expect(content, contains('Verify Runner Host'));
    });

    test('includes the macOS Verify Runner Host step', () {
      expect(content, contains('Verify macOS Runner Host'));
    });

    test('run steps use bash shell', () {
      final shellBashCount = 'shell: bash'.allMatches(content).length;
      expect(
        shellBashCount,
        greaterThanOrEqualTo(3),
        reason: 'Every run step must declare shell: bash',
      );
    });

    test('run steps enable strict mode with set -euo pipefail', () {
      final strictCount = 'set -euo pipefail'.allMatches(content).length;
      expect(
        strictCount,
        greaterThanOrEqualTo(3),
        reason:
            'Every run step should enable strict mode with set -euo pipefail',
      );
    });

    test('prints RUNNER_NAME environment variable', () {
      expect(content, contains(r'${RUNNER_NAME}'));
    });

    test('prints RUNNER_OS environment variable', () {
      expect(content, contains(r'${RUNNER_OS}'));
    });

    test('prints RUNNER_ARCH environment variable', () {
      expect(content, contains(r'${RUNNER_ARCH}'));
    });

    test('calls hostname', () {
      expect(content, contains('hostname'));
    });

    test('calls whoami', () {
      expect(content, contains('whoami'));
    });

    test('calls uname -a', () {
      expect(content, contains('uname -a'));
    });

    test('macOS host verification checks macOS and Xcode versions', () {
      expect(content, contains('sw_vers'));
      expect(content, contains('xcodebuild -version'));
    });
  });

  group('Verify Tooling step', () {
    test('includes the Verify Tooling step', () {
      expect(content, contains('Verify Tooling'));
    });

    test('Verify Tooling step also uses bash shell', () {
      final shellBashCount = 'shell: bash'.allMatches(content).length;
      expect(
        shellBashCount,
        greaterThanOrEqualTo(3),
        reason: 'Every run step must declare shell: bash',
      );
    });

    test('Verify Tooling also enables strict mode', () {
      final strictCount = 'set -euo pipefail'.allMatches(content).length;
      expect(
        strictCount,
        greaterThanOrEqualTo(3),
        reason:
            'Every run step should enable strict mode with set -euo pipefail',
      );
    });

    test('checks git version', () {
      expect(content, contains('git --version'));
    });

    test('checks docker version', () {
      expect(content, contains('docker --version'));
    });

    test('runs the hello-world Docker container smoke test', () {
      expect(content, contains('docker run --rm hello-world'));
    });

    test('docker run uses --rm to clean up after smoke test', () {
      // --rm prevents container accumulation on the self-hosted runner.
      expect(content, contains('--rm'));
    });
  });

  group('step ordering', () {
    test('checkout precedes runner-host verification', () {
      final checkoutIndex = content.indexOf('Checkout Repository');
      final verifyHostIndex = content.indexOf('Verify Runner Host');
      expect(
        checkoutIndex,
        lessThan(verifyHostIndex),
        reason: 'Repository must be checked out before host is verified',
      );
    });

    test('runner-host verification precedes tooling verification', () {
      final verifyHostIndex = content.indexOf('Verify Runner Host');
      final verifyToolingIndex = content.indexOf('Verify Tooling');
      expect(
        verifyHostIndex,
        lessThan(verifyToolingIndex),
        reason: 'Host must be verified before tooling is verified',
      );
    });
  });

  group('regression and boundary cases', () {
    test('workflow file is non-empty', () {
      expect(content.trim(), isNotEmpty);
    });

    test('workflow file is valid UTF-8 with no null bytes', () {
      expect(content, isNot(contains('\x00')));
    });

    test('on: block defines exactly the expected trigger branches', () {
      // Guard against accidental wildcards like "**" or "*" being added.
      final wildcardBranch = RegExp(r'^\s+-\s+\*', multiLine: true);
      expect(
        wildcardBranch.hasMatch(content),
        isFalse,
        reason: 'Branch triggers must not use wildcards',
      );
    });

    test('no write permissions are granted beyond contents: read', () {
      // The workflow only needs to read the repo; it must not request
      // write-level tokens that could be abused if the runner is compromised.
      expect(content, isNot(contains('contents: write')));
      expect(content, isNot(contains('packages: write')));
      expect(content, isNot(contains('id-token: write')));
      expect(content, isNot(contains('actions: write')));
    });
  });
}
