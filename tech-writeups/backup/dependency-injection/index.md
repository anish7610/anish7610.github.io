---
layout: default
title: dependency-injection 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Dependency Injection with Real-Life Examples

**Dependency Injection (DI)** is a design pattern used in software engineering to reduce tight coupling between components, making code more modular, testable, and maintainable. It allows objects to receive their dependencies from external sources rather than creating them internally.

---

##  What is Dependency Injection?

In traditional programming, a class often creates and manages its dependencies:

```python
class Service:
    def process(self):
        print("Processing...")

class Client:
    def __init__(self):
        self.service = Service()  # tightly coupled

    def do_work(self):
        self.service.process()
```

Here, `Client` is tightly coupled to `Service`. If we want to test `Client` with a mock or swap out `Service`, we’ll need to modify the code.

With **Dependency Injection**, we pass the dependency externally:

```python
class Client:
    def __init__(self, service):
        self.service = service

    def do_work(self):
        self.service.process()
```

Now, `Client` is decoupled from the `Service` implementation.

---

## ️ Types of Dependency Injection

1. **Constructor Injection**
   Dependencies are passed via the class constructor.

   ```python
   class Controller:
       def __init__(self, repository):
           self.repo = repository
   ```

2. **Setter Injection**
   Dependencies are set via setter methods after object construction.

   ```python
   controller = Controller()
   controller.set_repository(repo)
   ```

3. **Interface Injection** (less common in Python)
   The dependency exposes a method that the consumer calls to pass itself.

---

##  Real-Life Examples

### 1. **Web Applications (Flask)**

Using Flask with service classes:

```python
class UserService:
    def get_user(self, user_id):
        return {"id": user_id, "name": "Anish"}

class UserController:
    def __init__(self, user_service):
        self.user_service = user_service

    def get_user(self, user_id):
        return self.user_service.get_user(user_id)

# App setup
user_service = UserService()
user_controller = UserController(user_service)
```

This pattern allows you to replace `UserService` with a mock in tests.

---

### 2. **Testing with Mocks**

```python
class MockService:
    def process(self):
        print("Mocked!")

client = Client(MockService())
client.do_work()  # prints "Mocked!"
```

DI makes testing easy without needing complex setups or modifying core logic.

---

### 3. **JavaScript Frontend (React)**

React's **Context API** or props pattern is a form of dependency injection:

```jsx
function App() {
  return <UserProvider><Dashboard /></UserProvider>;
}

function Dashboard() {
  const user = useUser(); // injected from context
}
```

---

### 4. **Framework Support**

* **Spring (Java)** – built-in support for DI using annotations like `@Autowired`
* **Angular** – powerful DI system for injecting services into components
* **FastAPI / Flask / Django** – can implement DI via constructor-based or third-party libs like `dependency-injector`

---

##  Benefits of DI

* Loose coupling
* Easier unit testing
* Improved code reuse
* Swappable implementations (e.g., SQL vs NoSQL backends)

---

## ️ Caveats

* Can introduce complexity
* Overhead of managing containers/injectors
* May reduce readability for newcomers

---

##  Python Libraries for DI

* [`dependency-injector`](https://python-dependency-injector.ets-labs.org/)
* [`inject`](https://github.com/ivankorobkov/python-inject)

Example using `dependency-injector`:

```python
from dependency_injector import containers, providers

class Service:
    def process(self):
        print("Injected!")

class Container(containers.DeclarativeContainer):
    service = providers.Factory(Service)

container = Container()
service = container.service()
service.process()
```

---

##  Conclusion

Dependency Injection fosters flexibility and testability in modern codebases. While not always necessary in simple scripts, it becomes indispensable in large-scale applications and microservices where decoupling is key.

Use it when:

* Components have multiple responsibilities
* You need testability with mocks/stubs
* You want to follow SOLID principles (esp. the D in **D**IP)
