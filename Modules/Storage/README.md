# Storage

A single point of entry into the local storage. A wrapper around different storages: biometric, User Defaults, Keychain

## Installation

* Link StorageInterfaces package
* Link DependenciesInterfaces package
* Import StorageInterfaces
* Import DependenciesInterfaces
* Use `resolve()` to get live implementetion of the desired storage.

## Available storages

* SimpleStorage - User Defaults of file system wrapper. For storing common-knowledge, insignificant data. 
