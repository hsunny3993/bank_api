# Rails API for Bank Management
The API manages basic bank operations simply and contains features such as customer creation, account creation, get balance, 
deposit, withdraw, transfer, and transaction record.


## Ruby version
2.7.4

## Rails version
6.0.4

## OS
Ubuntu OS

## Database creation & initialization
Please prepare postgresql instance and create user `postgres` and password `solomon`
You can overwrite database user & pwd for your environment on `config/database.yml`

Environments can be one of "development", "production", "test"

`$ RAILS_ENV=development rails db:create`

`$ RAILS_ENV=development rails db:migrate`

`$ RAILS_ENV=development rails db:seed`


## Run API
`$ RAILS_ENV=[enviroment] rails s`

or if you want to run using puma,
`$ RAILS_ENV=[enviroment] puma -C config/puma.rb`

## API Documentation
After running the API, you can browse api documentation page on http://localhost:3000/apipie

## Deployment
The api can be containerized by docker and deployed on AWS ECS using CICD(Github Actions).

## API Test Workflow
You can test an API on https://ba8f-82-103-129-80.ngrok.io

When database migration was run, it seeds default user (email: admin@gmail.com, pass: solomon) on users table.
Please check attached  api requests sample exported from postman.

### Get auth token
At first, you need to get JWT authentication token in order to communicate with API.

```
GET https://ba8f-82-103-129-80.ngrok.io/authenticate
request: {
    "email": "admin@gmail.com",
    "password": "solomon"
}
response: {
    "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
```

Authentication token should be included into request's `Authorization` header as `Bearer #{token}`.

### Customers
#### Create a customer
Next, with authenticated token, you should create a customer of bank. At that time, account for this customer will be created with account_balance = 0.

Response will include created customer and account's ID

```
POST https://ba8f-82-103-129-80.ngrok.io/api/v1/customers
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
request: {
    "name": "test_customer_1",
    "email": "test_customer_1@gmail.com",
    "phone": "12312232340",
    "account_name": "HSBC"
}
response: {
    "id": 1,
    "name": "test_customer_1",
    "email": "test_customer_1@gmail.com",
    "phone": "12312232340",
    "account_id": 1,
    "account_number": "174417751156",
    "account_name": "HSBC"
}
```

#### Get a customer
```
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/customers/:customer_id
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/customers/1
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
response: {
    "id": 1,
    "name": "test_customer_1",
    "email": "test_customer_1@gmail.com",
    "phone": "12312232340",
    "created_at": "2022-02-07T10:12:41.025Z",
    "updated_at": "2022-02-07T10:12:41.025Z"
}
```

#### Get customers
```
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/customers
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
response: [
    {
        "id": 1,
        "name": "test_customer_1",
        "email": "test_customer_1@gmail.com",
        "phone": "12312232340",
        "created_at": "2022-02-07T10:12:41.025Z",
        "updated_at": "2022-02-07T10:12:41.025Z"
    }
]
```

#### Update a customer
```
PUT https://ba8f-82-103-129-80.ngrok.io/api/v1/customers/:customer_id
PUT https://ba8f-82-103-129-80.ngrok.io/api/v1/customers/1
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
request: {
    "name": "test_customer_1",
    "email": "test_customer_1@gmail.com",
    "phone": "12312232345"
}
response: {
    "id": 1,
    "name": "test_customer_1",
    "email": "test_customer_1@gmail.com",
    "phone": "12312232345",
    "created_at": "2022-02-07T10:12:41.025Z",
    "updated_at": "2022-02-07T10:21:32.574Z"
}
```

#### Destroy a customer
```
DELETE https://ba8f-82-103-129-80.ngrok.io/api/v1/customers/:customer_id
DELETE https://ba8f-82-103-129-80.ngrok.io/api/v1/customers/1
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
response: [
    {
        "id": 2,
        "name": "test_customer_2",
        "email": "test_customer_2@gmail.com",
        "phone": "12312232346",
        "created_at": "2022-02-07T10:12:41.025Z",
        "updated_at": "2022-02-07T10:21:32.574Z"
    }
]
```


### Accounts
#### Get balance
```
POST https://ba8f-82-103-129-80.ngrok.io/api/v1/accounts/balance
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
request: {
    "id": "2"
}
response: {
    "balance": "0.0"
}
```

#### Deposit onto account
```
POST https://ba8f-82-103-129-80.ngrok.io/api/v1/accounts/deposit
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
request: {
    "id": "2",
    "amount": "50.5"
}
response: {
    "account_balance": "50.5",
    "id": 2,
    "account_number": "506249398225",
    "customer_id": 2,
    "account_name": "HSBC",
    "created_at": "2022-02-07T10:25:29.791Z",
    "updated_at": "2022-02-07T10:30:17.718Z"
}
```

#### Withdraw onto account
```
POST https://ba8f-82-103-129-80.ngrok.io/api/v1/accounts/withdraw
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
request: {
    "id": "2",
    "amount": "50.5"
}
response: {
    "account_balance": "0.0",
    "id": 2,
    "account_number": "506249398225",
    "customer_id": 2,
    "account_name": "HSBC",
    "created_at": "2022-02-07T10:25:29.791Z",
    "updated_at": "2022-02-07T10:32:36.965Z"
}
```

#### Transfer between accounts
```
POST https://ba8f-82-103-129-80.ngrok.io/api/v1/accounts/transfer
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
request: {
    "from_account_id": "2",
    "to_account_id": "3",
    "amount": "50.5"
}
response: {
    "from": {
        "account_balance": "-50.5",
        "id": 2,
        "account_number": "506249398225",
        "customer_id": 2,
        "account_name": "HSBC",
        "created_at": "2022-02-07T10:25:29.791Z",
        "updated_at": "2022-02-07T10:35:22.991Z"
    },
    "to": {
        "account_balance": "50.5",
        "id": 3,
        "account_number": "515099069092",
        "customer_id": 3,
        "account_name": "HSBC",
        "created_at": "2022-02-07T10:34:19.558Z",
        "updated_at": "2022-02-07T10:35:22.999Z"
    }
}
```

#### Get an account
```
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/accounts/:account_id
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/accounts/1
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
response: {
    "id": 2,
    "customer_id": 2,
    "account_name": "HSBC",
    "account_number": "506249398225",
    "account_balance": "-50.5",
    "created_at": "2022-02-07T10:25:29.791Z",
    "updated_at": "2022-02-07T10:35:22.991Z"
}
```

### Transactions
#### Get transactions
```
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/transactions
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
response: [
    {
        "id": 1,
        "customer_id": 2,
        "account_id": 2,
        "debit_credit_flag": false,
        "amount": "50.5",
        "transaction_date": "2022-02-07T10:30:17.735Z",
        "created_at": "2022-02-07T10:30:17.748Z",
        "updated_at": "2022-02-07T10:30:17.748Z"
    },
    ...
    {
        "id": 7,
        "customer_id": 3,
        "account_id": 2,
        "debit_credit_flag": false,
        "amount": "50.5",
        "transaction_date": "2022-02-07T10:43:42.176Z",
        "created_at": "2022-02-07T10:43:42.201Z",
        "updated_at": "2022-02-07T10:43:42.201Z"
    }
]
```

#### Get a transaction
```
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/transactions/:transaction_id
GET https://ba8f-82-103-129-80.ngrok.io/api/v1/transactions/1
header: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDQzMTUwOTN9.7sfQSSL99k1GXiq4n8tKeKs2LpDmlKL9q5id4qyPAJA"
}
response: {
    "id": 1,
    "customer_id": 2,
    "account_id": 2,
    "debit_credit_flag": false,
    "amount": "50.5",
    "transaction_date": "2022-02-07T10:30:17.735Z",
    "created_at": "2022-02-07T10:30:17.748Z",
    "updated_at": "2022-02-07T10:30:17.748Z"
}
```

## Testing the API
Please run following command on API root directory.

`RAILS_ENV=test rspec`

## My Suggestion
If I can get an AWS environment for this API, I can implemented containerization for API, deploy it onto ECS using CICD(Github Actions), and setup Load Balancing, Log Tracking, Auto-Scaling on AWS. 