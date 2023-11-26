# Concerns
This document describes the concerns of the user management service. They may or may not be addressed, but in line 
the purposes of this project, they are noted here.

## User name limitations
Usernames are unique, but can be any string allowed within database constraints. These constraints are not finalized.

There are a lot of potential cases where this could be undesirable, but for the purposes of this project, it is sufficient.

## User password limitations
While passwords are encoded, password strength is not enforced. This is a potential security concern, but for the purposes
of this project, it is sufficient.