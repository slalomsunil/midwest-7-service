---
applyTo: "**/*.py"
---

# Python Instructions

**Tool:** GitHub Copilot
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `../../generic/tech/python.md` for detailed patterns, `../../cursor/tech/python.mdc` for Cursor version

> This file follows GitHub Copilot's custom instructions format and can be placed in `.github/instructions/` for path-specific Python guidance.

---

Follow PEP 8 style guide. Use Black for automatic formatting with 88 character line length.

Add type hints to all function parameters and return values:
```python
def get_user(user_id: int) -> User | None:
    return users.get(user_id)

def process_items(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}
```

Use modern type syntax (Python 3.10+): `int | str` instead of `Union[int, str]`, `list[str]` instead of `List[str]`.

Handle None explicitly. Use `Optional[T]` or `T | None` for nullable types. Use `ArgumentNullException.ThrowIfNull()` equivalent checks.

Use docstrings for all public functions, classes, and modules. Include Args, Returns, Raises, and Examples sections.

Avoid mutable default arguments. Use `None` and create new list/dict inside function.

Use `*args` for variable positional arguments, `**kwargs` for variable keyword arguments.

Structure classes with `__init__`, then public methods, then private methods (prefixed with `_`).

Use dataclasses for data containers with automatic `__init__`, `__repr__`, and `__eq__`.

Use `@property` for computed attributes and controlled access to private attributes.

Handle exceptions with specific types. Create custom exception classes inheriting from Exception.

Use context managers (`with` statement) for resource management.

Use list comprehensions for simple transformations. Use generators for large datasets. Avoid overly complex comprehensions.

Use f-strings for string formatting. Use `str.format()` for complex formatting needs.

Use pathlib.Path for file operations instead of os.path. Use async file operations in async contexts.

For async code, use `async`/`await` consistently. Use `asyncio.gather()` for concurrent operations.

Test with pytest. Use fixtures for setup. Use parametrize for multiple test cases. Use descriptive test names.

Use virtual environments (venv) for dependencies. Use pyproject.toml for modern project configuration.

Use snake_case for functions and variables, PascalCase for classes, UPPER_SNAKE_CASE for constants.

Import order: standard library, third-party packages, local imports. Use absolute imports over relative.
