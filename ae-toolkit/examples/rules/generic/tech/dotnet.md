# .NET and C#

<!-- Rule Metadata -->
**Tool:** Claude Code, OpenCode
**Version:** 2025-01
**Category:** Technology-Specific Rules
**Related:** See `./copilot/dotnet.md` for GitHub Copilot version, `./cursor/dotnet.md` for Cursor version

## Purpose

Establish .NET and C#-specific conventions and patterns that promote maintainability, performance, and alignment with modern .NET practices.

## Naming Conventions

### Follow .NET Conventions

- **Classes, Methods, Properties:** `PascalCase`
- **Interfaces:** `IPascalCase` (with `I` prefix)
- **Local variables, parameters:** `camelCase`
- **Private fields:** `_camelCase` (with underscore prefix)
- **Constants:** `PascalCase`
- **Async methods:** Include `Async` suffix

**Examples:**
```csharp
public class UserService
{
    private readonly IUserRepository _userRepository;
    private const int MaxRetries = 3;

    public async Task<User> GetUserAsync(string userId)
    {
        var user = await _userRepository.FindByIdAsync(userId);
        return user;
    }
}
```

## Nullable Reference Types

### Enable Nullable Reference Types

In `.csproj` or `Directory.Build.props`:
```xml
<PropertyGroup>
  <Nullable>enable</Nullable>
</PropertyGroup>
```

### Handle Nullability Explicitly

**Good:**
```csharp
public User? FindUser(string id)
{
    return _users.FirstOrDefault(u => u.Id == id);
}

public string GetDisplayName(User? user)
{
    return user?.Name ?? "Guest";
}

public void ProcessUser(User user) // Never null
{
    ArgumentNullException.ThrowIfNull(user);
    Console.WriteLine(user.Name); // Safe to access
}
```

### Null Checking

```csharp
// Modern null checks (.NET 6+)
ArgumentNullException.ThrowIfNull(user);

// Null-conditional operator
var email = user?.Email?.ToLower();

// Null-coalescing operator
var name = user?.Name ?? "Unknown";

// Null-coalescing assignment
_cache ??= new Dictionary<string, string>();
```

## Async/Await

### Async Best Practices

**Always use async/await for I/O operations:**
```csharp
public async Task<User> GetUserAsync(int id)
{
    using var client = new HttpClient();
    var response = await client.GetStringAsync($"/api/users/{id}");
    return JsonSerializer.Deserialize<User>(response);
}
```

**Return Task directly when no await needed:**
```csharp
// Good - no unnecessary state machine
public Task<User> GetUserAsync(int id)
{
    return _repository.FindByIdAsync(id);
}

// Unnecessary - adds overhead
public async Task<User> GetUserAsync(int id)
{
    return await _repository.FindByIdAsync(id);
}
```

**Use ConfigureAwait(false) in libraries:**
```csharp
public async Task<Data> LoadDataAsync()
{
    var response = await httpClient.GetAsync(url).ConfigureAwait(false);
    return await response.Content.ReadAsAsync<Data>().ConfigureAwait(false);
}
```

**Name async methods with Async suffix:**
```csharp
public async Task<User> GetUserAsync(int id) { }
public async Task SaveUserAsync(User user) { }
```

## LINQ and Collections

### Use LINQ Effectively

**Prefer LINQ methods:**
```csharp
// Good
var activeUsers = users.Where(u => u.IsActive).ToList();
var names = users.Select(u => u.Name);
var firstAdmin = users.FirstOrDefault(u => u.Role == "Admin");

// Avoid
var activeUsers = new List<User>();
foreach (var user in users)
{
    if (user.IsActive)
        activeUsers.Add(user);
}
```

**Use appropriate collection types:**
```csharp
// Use IEnumerable<T> for parameters (most flexible)
public void ProcessUsers(IEnumerable<User> users) { }

// Use IReadOnlyList<T> when index access needed
public User GetByIndex(IReadOnlyList<User> users, int index) { }

// Use List<T> for return values when mutation expected
public List<User> GetActiveUsers() { }

// Use IReadOnlyCollection<T> for return values
public IReadOnlyCollection<User> GetUsers() => _users.AsReadOnly();
```

### Avoid Deferred Execution Issues

```csharp
// Good - materialized immediately
var users = dbContext.Users.Where(u => u.IsActive).ToList();

// Risky - query executes multiple times
var users = dbContext.Users.Where(u => u.IsActive);
var count = users.Count(); // Query 1
var first = users.First(); // Query 2
```

## Error Handling

### Use Specific Exception Types

**Good:**
```csharp
public class UserNotFoundException : Exception
{
    public UserNotFoundException(string userId)
        : base($"User with ID '{userId}' was not found.") { }
}

public User GetUser(string id)
{
    var user = _repository.Find(id);
    if (user == null)
        throw new UserNotFoundException(id);
    return user;
}
```

### Use Try Patterns When Appropriate

```csharp
// Dictionary
if (_cache.TryGetValue(key, out var value))
{
    return value;
}

// Parse
if (int.TryParse(input, out var number))
{
    return number;
}
```

### Exception Filters

```csharp
try
{
    await ProcessAsync();
}
catch (HttpRequestException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
{
    // Handle 404 specifically
}
catch (HttpRequestException ex) when (ex.StatusCode == HttpStatusCode.Unauthorized)
{
    // Handle 401 specifically
}
```

## Dependency Injection

### Follow DI Patterns

**Register services:**
```csharp
// Program.cs or Startup.cs
services.AddScoped<IUserService, UserService>();
services.AddSingleton<ICacheService, CacheService>();
services.AddTransient<IEmailSender, EmailSender>();
```

**Constructor injection:**
```csharp
public class UserController : ControllerBase
{
    private readonly IUserService _userService;
    private readonly ILogger<UserController> _logger;

    public UserController(IUserService userService, ILogger<UserController> logger)
    {
        _userService = userService;
        _logger = logger;
    }
}
```

### Service Lifetimes

- **Transient:** New instance every time (stateless services)
- **Scoped:** One instance per request (DbContext, request-specific services)
- **Singleton:** One instance for application lifetime (caches, configuration)

## Modern C# Features

### Pattern Matching

```csharp
// Switch expressions
var message = user.Role switch
{
    "Admin" => "Welcome, administrator!",
    "User" => "Welcome, user!",
    _ => "Welcome, guest!"
};

// Type patterns
if (obj is User user)
{
    Console.WriteLine(user.Name);
}

// Property patterns
if (user is { IsActive: true, Role: "Admin" })
{
    // User is active admin
}
```

### Record Types

Use records for immutable data:
```csharp
public record User(string Id, string Name, string Email);

public record User
{
    public required string Id { get; init; }
    public required string Name { get; init; }
    public string? Email { get; init; }
}
```

### Init-only Properties

```csharp
public class User
{
    public string Id { get; init; }
    public string Name { get; init; }
}

var user = new User { Id = "123", Name = "Alice" };
// user.Name = "Bob"; // Compile error
```

### Target-typed New

```csharp
// Instead of
List<string> names = new List<string>();

// Use
List<string> names = new();
```

### String Interpolation

```csharp
// Prefer interpolation
var message = $"Hello, {user.Name}!";

// Over concatenation
var message = "Hello, " + user.Name + "!";

// Formatted numbers
var price = $"Total: ${amount:F2}";

// Alignment and formatting
var report = $"{"Name",-20} {"Score",5}";
```

## Performance Considerations

### Use Span<T> and Memory<T>

For performance-critical code:
```csharp
public void ProcessData(ReadOnlySpan<byte> data)
{
    // Zero-allocation substring
    var slice = data.Slice(0, 10);
}
```

### Avoid Boxing

```csharp
// Avoid
object value = 42; // Boxing
int number = (int)value; // Unboxing

// Prefer generics
public T GetValue<T>() { }
```

### Use ValueTask for High-Performance Scenarios

```csharp
public ValueTask<int> GetCachedValueAsync(string key)
{
    if (_cache.TryGetValue(key, out var value))
        return new ValueTask<int>(value); // Synchronous completion

    return LoadFromDatabaseAsync(key); // Async path
}
```

## Configuration and Options Pattern

### Use Options Pattern

```csharp
// appsettings.json
{
  "Email": {
    "Server": "smtp.example.com",
    "Port": 587
  }
}

// Configuration class
public class EmailOptions
{
    public string Server { get; set; } = string.Empty;
    public int Port { get; set; }
}

// Registration
services.Configure<EmailOptions>(configuration.GetSection("Email"));

// Usage
public class EmailService
{
    private readonly EmailOptions _options;

    public EmailService(IOptions<EmailOptions> options)
    {
        _options = options.Value;
    }
}
```

## Testing

### Naming Test Methods

```csharp
[Fact]
public void GetUser_WithValidId_ReturnsUser() { }

[Fact]
public void GetUser_WithInvalidId_ThrowsNotFoundException() { }

// Or use underscores for readability
[Fact]
public void Get_user_with_valid_id_returns_user() { }
```

### Use FluentAssertions

```csharp
// Readable assertions
result.Should().NotBeNull();
result.Should().BeOfType<User>();
result.Name.Should().Be("Alice");
users.Should().HaveCount(3);
await action.Should().ThrowAsync<ArgumentException>();
```

## Common Patterns

### Repository Pattern

```csharp
public interface IRepository<T> where T : class
{
    Task<T?> GetByIdAsync(int id);
    Task<IEnumerable<T>> GetAllAsync();
    Task AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(int id);
}
```

### Unit of Work Pattern

```csharp
public interface IUnitOfWork : IDisposable
{
    IUserRepository Users { get; }
    IOrderRepository Orders { get; }
    Task<int> SaveChangesAsync();
}
```

### Result Pattern

```csharp
public class Result<T>
{
    public bool IsSuccess { get; }
    public T? Value { get; }
    public string? Error { get; }

    public static Result<T> Success(T value) => new(true, value, null);
    public static Result<T> Failure(string error) => new(false, default, error);
}
```

## Integration with Other Rules

.NET rules work with:
- **Code Quality** - Follow C# conventions for maintainability
- **Testing** - Use xUnit, NUnit, or MSTest with proper assertions
- **API Design** - RESTful API patterns with ASP.NET Core
- **Database** - Entity Framework Core patterns

## Customization Notes

Teams may want to adjust:
- Naming conventions (especially private fields)
- Whether to use ConfigureAwait in all contexts
- Exception handling strategy
- DI container choice (built-in vs Autofac vs others)
- ORM choice (EF Core, Dapper, etc.)
- Logging framework (ILogger, Serilog, NLog)
