# React Hooks

## Dispatcher

> Dispatcher 负责管理hooks 的生命周期

+ The dispatcher is the shared object that contains the hook functions
+ It will be dynamically allocated or cleaned up based on the rendering phase of ReactDOM,
+ When we’re done performing the rendering work, we nullify the dispatcher and thus preventing hooks from being accidentally used outside ReactDOM’s rendering cycle



## Hooks Queue

+ hooks are represented as nodes which are linked together in their calling order.

### hook schema

 hook has several properties

- Its initial state is created in the initial render.
- Its state can be updated on the fly.
- React would remember the hook’s state in future renders.
- React would provide you with the right state based on the calling order.
- React would know which fiber does this hook belong to.



we need to rethink the way we view the a component’s state. So far we have thought about it as if it’s a plain object:

```js
{
  foo: 'foo',
  bar: 'bar',
  baz: 'baz',
}
```

when dealing with hooks it should be viewed as a queue, where each node represents a single model of the state

```js
{
  memoizedState: 'foo',
  next: {
    memoizedState: 'bar',
    next: {
      memoizedState: 'bar',
      next: null
    }
  }
}
```

the schema of a single hook node can be viewed in the[React Hook: createHook implemenet](https://github.com/facebook/react/blob/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L243)

the key for understanding how hooks work lies within `memoizedState` and `next`. 

The rest of the properties are used specifically by the `useReducer()` hook to cache dispatched actions and base states

### hook call

before each and every function Component invocation, a function named [`prepareHooks()`](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:123) is gonna be called, where the current fiber and its first hook node in the hooks queue are gonna be stored in global variables.This way, any time we call a hook function (`useXXX()`) it would know in which context to run.

```js
function updateFunctionComponent(
  recentFiber,
  workInProgressFiber,
  Component,
  props
) {
  prepareHooks(recentFiber, workInProgressFiber);
  Component(props);
  finishHooks();
}
```

Once an update has finished, a function named [`finishHooks()`](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:148) will be called, where a reference for the first node in the hooks queue will be stored on the rendered fiber in the `memoizedState` property.

### state hook

You would be surprised to know, but behind the scenes the `useState` hook uses `useReducer` and it simply provides it with a pre-defined reducer handler (see [implementation](https://github.com/facebook/react/blob/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L339))



So as expected, we can provide the action dispatcher with the new state directly;

```js
const ParentComponent = () => {
  const [name, setName] = useState();

  return <ChildComponent toUpperCase={setName} />;
};

const ChildComponent = (props) => {
  useEffect(() => {
    props.toUpperCase((state) => state.toUpperCase());
  }, [true]);

  return null;
};
```

### Effect hooks

- They’re created during render time, but they run *after* painting.
- If given so, they’ll be destroyed right before the next painting.
- They’re called in their definition order.