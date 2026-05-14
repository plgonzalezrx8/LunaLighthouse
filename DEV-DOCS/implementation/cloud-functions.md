# Cloud Functions

## Purpose

`luna_lighthouse-cloud-functions/functions/` contains Firebase Cloud Functions for backend cleanup. These functions are part of the deferred cloud surface for phase 1, but they document the existing account-data deletion behavior.

## Delete User Flow

`functions/src/index.ts` initializes Firebase Admin and exports `deleteUserController`.

`functions/src/controllers/delete_user.ts` registers an Auth `onDelete` handler. When a Firebase user is deleted, it calls:

- `Firestore.deleteUser(user)`
- `Storage.deleteUser(user)`

## Firestore Cleanup

`functions/src/services/firestore/delete_user.ts` deletes the root document at `users/{uid}` after recursively listing and deleting nested collection documents.

## Storage Cleanup

`functions/src/services/storage/index.ts` points to bucket `backup.lunalighthouse.app`.

`functions/src/services/storage/delete_user.ts` deletes files under the deleted user's prefix: `${user.uid}/`.

## Runtime

`functions/package.json` targets Node 20 and includes scripts for build, emulator serve, shell, deploy, and function logs.
