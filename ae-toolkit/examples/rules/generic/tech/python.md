# Python

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `./copilot/python.md` for GitHub Copilot version, `./cursor/python.md` for Cursor version

## Purpose

Establish Python-specific conventions and patterns aligned with PEP 8 and modern Python practices for readable, maintainable code.

## Code Style

### Follow PEP 8

Use PEP 8 style guide basics:

```python
# Good naming
class UserAccount:
    pass

def calculate_total(items):
    pass

MAX_CONNECTIONS = 100
user_count = 0

# Spacing
x = 1
y = 2
result = x + y

# Not
x=1
y=2
result = x+y
```

### Use Black for Formatting

Configure Black for consistent formatting:

```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py311']
```

### Line Length

Keep lines under 88 characters (Black default) or 79 (PEP 8):

```python
# Good - readable
result = some_function(
    parameter1="value1",
    parameter2="value2",
    parameter3="value3"
)

# Avoid - too long
result = some_function(parameter1="value1", parameter2="value2", parameter3="value3", parameter4="value4")
```

## Type Hints

### Use Type Hints

Add type hints for function parameters and return values:

```python
from typing import List, Dict, Optional, Union

def get_user(user_id: int) -> Optional[User]:
    return users.get(user_id)

def process_items(items: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in items}

def calculate_total(
    items: List[float],
    tax_rate: float = 0.0
) -> float:
    subtotal = sum(items)
    return subtotal * (1 + tax_rate)
```

### Modern Type Syntax (Python 3.10+)

```python
# Union types
def process_value(value: int | str) -> str:
    return str(value)

# Optional
def find_user(user_id: int) -> User | None:
    return users.get(user_id)

# Generic types (Python 3.9+)
def first(items: list[str]) -> str | None:
    return items[0] if items else None
```

### Type Checking

Use mypy for static type checking:

```bash
mypy src/
```

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
```

## Functions and Methods

### Function Documentation

Use docstrings with proper formatting:

```python
def calculate_discount(
    price: float,
    discount_percent: float,
    min_price: float = 0.0
) -> float:
    """Calculate discounted price with minimum threshold.

    Args:
        price: Original price
        discount_percent: Discount percentage (0-100)
        min_price: Minimum allowed price

    Returns:
        Discounted price, not less than min_price

    Raises:
        ValueError: If discount_percent is not between 0 and 100

    Example:
        >>> calculate_discount(100, 20, 50)
        80.0
    """
    if not 0 <= discount_percent <= 100:
        raise ValueError("Discount must be between 0 and 100")

    discounted = price * (1 - discount_percent / 100)
    return max(discounted, min_price)
```

### Default Arguments

Be careful with mutable defaults:

```python
# Bad - mutable default
def add_item(item: str, items: list = []):
    items.append(item)
    return items

# Good - use None and create new list
def add_item(item: str, items: list | None = None) -> list:
    if items is None:
        items = []
    items.append(item)
    return items
```

### *args and **kwargs

```python
def log_message(level: str, *messages: str, **context: str) -> None:
    """Log messages with context.

    Args:
        level: Log level (info, warning, error)
        *messages: Variable number of message strings
        **context: Additional context as key-value pairs
    """
    msg = " ".join(messages)
    ctx = ", ".join(f"{k}={v}" for k, v in context.items())
    print(f"[{level}] {msg} ({ctx})")

# Usage
log_message("info", "User", "logged in", user_id="123", ip="192.168.1.1")
```

## Classes

### Class Structure

```python
from dataclasses import dataclass
from typing import ClassVar

class UserService:
    """Service for managing user operations."""

    MAX_LOGIN_ATTEMPTS: ClassVar[int] = 3

    def __init__(self, repository: UserRepository) -> None:
        self._repository = repository
        self._cache: dict[int, User] = {}

    def get_user(self, user_id: int) -> User | None:
        """Retrieve user by ID, with caching."""
        if user_id in self._cache:
            return self._cache[user_id]

        user = self._repository.find(user_id)
        if user:
            self._cache[user_id] = user
        return user

    def _clear_cache(self) -> None:
        """Private method to clear cache."""
        self._cache.clear()
```

### Dataclasses

Use dataclasses for data containers:

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    id: int
    name: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)
    tags: list[str] = field(default_factory=list)

    def __post_init__(self) -> None:
        """Validate after initialization."""
        if not self.email:
            raise ValueError("Email is required")

# Usage
user = User(id=1, name="Alice", email="alice@example.com")
```

### Properties

```python
class Temperature:
    def __init__(self, celsius: float) -> None:
        self._celsius = celsius

    @property
    def celsius(self) -> float:
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        if value < -273.15:
            raise ValueError("Temperature below absolute zero")
        self._celsius = value

    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self.celsius = (value - 32) * 5/9
```

## Error Handling

### Exception Handling

```python
# Good - specific exceptions
try:
    user = get_user(user_id)
    process_user(user)
except UserNotFoundError as e:
    logger.error(f"User not found: {e}")
    raise
except ValidationError as e:
    logger.warning(f"Invalid user data: {e}")
    return default_user
except Exception as e:
    logger.exception("Unexpected error")
    raise

# Bad - bare except
try:
    risky_operation()
except:  # Catches everything, including KeyboardInterrupt
    pass
```

### Custom Exceptions

```python
class ApplicationError(Exception):
    """Base exception for application errors."""
    pass

class UserNotFoundError(ApplicationError):
    """Raised when user is not found."""

    def __init__(self, user_id: int) -> None:
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")

class ValidationError(ApplicationError):
    """Raised when validation fails."""

    def __init__(self, field: str, message: str) -> None:
        self.field = field
        super().__init__(f"{field}: {message}")
```

### Context Managers

```python
from contextlib import contextmanager

# Using built-in context managers
with open("file.txt") as f:
    content = f.read()

# Custom context manager
@contextmanager
def database_transaction(conn):
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise

# Usage
with database_transaction(conn) as db:
    db.execute("INSERT ...")
```

## Collections and Iterators

### List Comprehensions

```python
# Good - readable comprehensions
squares = [x**2 for x in range(10)]
evens = [x for x in numbers if x % 2 == 0]
pairs = [(x, y) for x in range(3) for y in range(3)]

# Avoid - too complex
result = [x**2 for x in range(10) if x % 2 == 0 if x > 5 if x < 9]

# Better - use filter and map or explicit loop
result = [x**2 for x in range(10) if x % 2 == 0 and 5 < x < 9]
```

### Generators

```python
def read_large_file(file_path: str):
    """Generator to read file line by line."""
    with open(file_path) as f:
        for line in f:
            yield line.strip()

# Generator expression
squares = (x**2 for x in range(1000000))  # Memory efficient

# Usage
for line in read_large_file("large.txt"):
    process_line(line)
```

### Dictionary Operations

```python
# Dictionary comprehension
user_map = {user.id: user for user in users}

# Get with default
count = counters.get(key, 0)

# setdefault
counters.setdefault(key, 0)
counters[key] += 1

# defaultdict
from collections import defaultdict

counters = defaultdict(int)
counters[key] += 1  # No need to check if key exists
```

## Async/Await

### Async Functions

```python
import asyncio
from typing import List

async def fetch_user(user_id: int) -> User:
    """Fetch user asynchronously."""
    async with httpx.AsyncClient() as client:
        response = await client.get(f"/api/users/{user_id}")
        return User(**response.json())

async def fetch_multiple_users(user_ids: List[int]) -> List[User]:
    """Fetch multiple users concurrently."""
    tasks = [fetch_user(user_id) for user_id in user_ids]
    return await asyncio.gather(*tasks)

# Run async code
users = asyncio.run(fetch_multiple_users([1, 2, 3]))
```

### Async Context Managers

```python
class AsyncDatabaseConnection:
    async def __aenter__(self):
        await self.connect()
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await self.disconnect()

# Usage
async with AsyncDatabaseConnection() as db:
    await db.query("SELECT * FROM users")
```

## File Operations

### Path Handling

```python
from pathlib import Path

# Prefer pathlib over os.path
project_root = Path(__file__).parent.parent
config_file = project_root / "config" / "settings.json"

# Read file
content = config_file.read_text()

# Write file
config_file.write_text(content)

# Check existence
if config_file.exists():
    print("File exists")

# Iterate directory
for file in project_root.glob("**/*.py"):
    print(file)
```

### File I/O

```python
# Read file
with open("data.txt") as f:
    content = f.read()

# Read lines
with open("data.txt") as f:
    lines = f.readlines()

# Write file
with open("output.txt", "w") as f:
    f.write("Hello, world!\n")

# Append to file
with open("log.txt", "a") as f:
    f.write(f"Log entry: {message}\n")

# Binary files
with open("image.png", "rb") as f:
    data = f.read()
```

## Testing

### pytest Basics

```python
# test_calculator.py
import pytest
from calculator import add, divide

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

def test_divide():
    assert divide(10, 2) == 5

def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

@pytest.mark.parametrize("a,b,expected", [
    (1, 1, 2),
    (2, 3, 5),
    (-1, 1, 0),
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected
```

### Fixtures

```python
import pytest

@pytest.fixture
def sample_user():
    return User(id=1, name="Alice", email="alice@example.com")

@pytest.fixture
def database():
    db = Database()
    db.connect()
    yield db
    db.disconnect()

def test_user_creation(sample_user):
    assert sample_user.name == "Alice"

def test_database_query(database):
    result = database.query("SELECT * FROM users")
    assert len(result) > 0
```

### Mocking

```python
from unittest.mock import Mock, patch

def test_fetch_user():
    with patch('requests.get') as mock_get:
        mock_get.return_value.json.return_value = {"id": 1, "name": "Alice"}

        user = fetch_user(1)

        assert user.name == "Alice"
        mock_get.assert_called_once_with("/api/users/1")
```

## Virtual Environments

### Setup

```bash
# Create virtual environment
python -m venv venv

# Activate
# Linux/Mac
source venv/bin/activate
# Windows
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Freeze dependencies
pip freeze > requirements.txt
```

### pyproject.toml

Modern Python projects use pyproject.toml:

```toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "myapp"
version = "1.0.0"
description = "My application"
requires-python = ">=3.11"
dependencies = [
    "requests>=2.28.0",
    "pydantic>=2.0.0"
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "mypy>=1.0.0",
    "black>=23.0.0"
]
```

## Common Patterns

### Context Management

```python
# Resource cleanup
with resource_manager() as resource:
    resource.use()
# Automatic cleanup
```

### Decorators

```python
from functools import wraps
import time

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.2f}s")
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)
```

### Enums

```python
from enum import Enum, auto

class Status(Enum):
    PENDING = auto()
    ACTIVE = auto()
    INACTIVE = auto()

# Usage
user_status = Status.ACTIVE
if user_status == Status.ACTIVE:
    print("User is active")
```

## Integration with Other Rules

Python rules work with:
- **Code Quality** - PEP 8 compliance, type checking
- **Testing** - pytest for comprehensive testing
- **Data Science** - NumPy, Pandas, Jupyter notebooks
- **Web** - FastAPI, Django, Flask frameworks

## Customization Notes

Teams may want to adjust:
- Line length (79 vs 88 vs 100 characters)
- Docstring format (Google vs NumPy vs Sphinx)
- Type checking strictness
- Testing framework (pytest vs unittest)
- Linting tools (pylint, flake8, ruff)
- Formatter configuration (Black settings)
