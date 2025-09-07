---
layout: default
title: react-redux-state-management
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# State Management in React: Redux, Context API, Recoil

Managing state is a cornerstone of building reliable, scalable, and maintainable React applications. As apps grow, so does the complexity of managing shared state across components. This article compares three widely used tools for managing state in React: **Redux**, **Context API**, and **Recoil**.

---

##  What is State in React?

In React, **state** refers to data that changes over time and affects what is rendered. While local state (via `useState`) works well for isolated components, it becomes harder to manage as the app grows and more components need access to the same state.

---

## 1.  Redux

### Overview:

Redux is a **predictable state container** based on a unidirectional data flow pattern. It maintains application state in a single store and updates it through actions and reducers.

### Key Concepts:

* **Store**: Holds the global application state.
* **Actions**: Plain JavaScript objects that describe what happened.
* **Reducers**: Pure functions that take previous state and action, and return the next state.
* **Middleware**: Used for side effects like API calls (e.g., Redux Thunk, Redux Saga).

### Pros:

* Mature ecosystem and community support.
* Time-travel debugging and DevTools.
* Enforces a clear data flow and separation of concerns.

### Cons:

* Verbose boilerplate.
* Overhead for small to medium apps.
* Asynchronous handling can feel complex.

### Usage Example:

```js
// actions.js
export const increment = () => ({ type: 'INCREMENT' });

// reducer.js
const counter = (state = 0, action) => {
  switch (action.type) {
    case 'INCREMENT': return state + 1;
    default: return state;
  }
};

// store.js
const store = createStore(counter);

// Component
const Counter = () => {
  const count = useSelector(state => state);
  const dispatch = useDispatch();
  return <button onClick={() => dispatch(increment())}>{count}</button>;
};
```

---

## 2.  Context API

### Overview:

React’s built-in **Context API** is used for **prop drilling elimination** and light state management across components.

### Key Concepts:

* **Provider**: Holds the state and provides it to descendants.
* **Consumer / useContext Hook**: Consumes the context.

### Pros:

* Native to React — no external libraries.
* Simple to set up.
* Ideal for themes, auth, locales.

### Cons:

* Not optimized for frequent updates.
* Triggers re-renders on any value change.
* Difficult to manage deeply nested or large state trees.

### Usage Example:

```js
const CountContext = React.createContext();

const CounterProvider = ({ children }) => {
  const [count, setCount] = useState(0);
  return (
    <CountContext.Provider value={{ count, setCount }}>
      {children}
    </CountContext.Provider>
  );
};

const Counter = () => {
  const { count, setCount } = useContext(CountContext);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
};
```

---

## 3. ️ Recoil

### Overview:

**Recoil** is a modern experimental state management library for React by Facebook. It introduces the concept of **atoms** (shared state) and **selectors** (derived state) with fine-grained updates.

### Key Concepts:

* **Atoms**: Units of state.
* **Selectors**: Compute derived state.
* **RecoilRoot**: Top-level provider.

### Pros:

* Easy to use with React’s functional API.
* Fine-grained subscriptions — fewer re-renders.
* Derived/computed state is built-in.
* Concurrent Mode compatible.

### Cons:

* Experimental and evolving.
* Smaller community than Redux.

### Usage Example:

```js
import { atom, selector, useRecoilState } from 'recoil';

const countState = atom({
  key: 'countState',
  default: 0,
});

const Counter = () => {
  const [count, setCount] = useRecoilState(countState);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
};
```

---

## ️ Comparison Summary

| Feature          | Redux                      | Context API               | Recoil                    |
| ---------------- | -------------------------- | ------------------------- | ------------------------- |
| Boilerplate      | High                       | Low                       | Low                       |
| DevTools Support | Excellent                  | Minimal                   | Moderate                  |
| Async Handling   | Middleware (Thunk, Saga)   | Manual with hooks         | Built-in with selectors   |
| Performance      | Efficient with memoization | Poor for frequent changes | Fine-grained atom updates |
| Ecosystem        | Mature                     | Native                    | Growing                   |
| Use Case Fit     | Large apps                 | Small to medium apps      | Medium to large apps      |

---

##  When to Use What?

* **Redux**: Ideal for large-scale applications with complex state logic, strict architectural needs, and the need for debugging tools.
* **Context API**: Suitable for simple use cases like theme, language, or authentication state.
* **Recoil**: Great for medium to large applications that want better performance and a more modern, flexible approach without Redux’s boilerplate.

---

##  Conclusion

State management is not one-size-fits-all. Choose based on your **app size**, **complexity**, **performance needs**, and **team familiarity**. Modern React applications can even mix and match — using Context for auth, Redux for global app state, and Recoil for local yet shared atoms.
