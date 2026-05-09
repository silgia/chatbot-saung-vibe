# Messages API Prompt

## Template
### Endpoint
- GET
- POST
- PUT
- DELETE

### Request
{
  "content": "string"
}

### Response
{
  "id": number,
  "content": "string"
}

---

## Example
### Endpoint
- GET /messages
- POST /messages

### Request
{
  "content": "Halo"
}

### Response
{
  "id": 1,
  "content": "Halo"
}