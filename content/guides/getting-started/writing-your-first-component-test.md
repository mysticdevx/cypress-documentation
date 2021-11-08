---
title: Writing Your First Component Test
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> What you'll learn

- How to start testing components in Cypress.
- How to mount a component and test that it renders correctly.
- How to query the DOM, stub functions, and write assertions.
- What passing and failing tests look like.
- How to use the Cypress UI to help debug test results.

</Alert>

In order to get the most out of this guide, we recommend that you follow along
by cloning the
[cypress-component-testing-example](https://github.com/cypress-io/cypress-component-testing-examples)
repo and then following the instructions at the top of the README of either of
the following folders to get started:

- React version:
  [first-component-react](https://github.com/cypress-io/cypress-component-testing-examples/tree/main/first-component-react)
- Vue version:
  [first-component-vue](https://github.com/cypress-io/cypress-component-testing-examples/tree/main/first-component-vue)

(more explanation about cloning the repo or getting started with one of the
examples?)

## The example component

We're going to be testing a `LoginForm` component. This component is similar to
many of the components you will be testing in your application, in that it
accepts props and renders elements into the DOM that a user can interact with.

More specifically, the `LoginForm` component:

- is a login form, with a title, input fields for the user name and password,
  and a submit button.
- has a `title` prop with a default value, that can be overridden.
- has an `onLogin` function prop that will be called with the entered `username`
  and `password` when the user clicks the "Login" button or presses `{enter}` in
  one of the input fields.
- has per-field validation error messages that display if either field is left
  empty when submitting, but only after the user has attempted to submit the
  form.

Here's the component:

<code-group>
<code-block label="React" active>

```js
const LoginForm = ({ onLogin, title = 'Log In' }) => {
  const [submitted, setSubmitted] = useState(false)
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')

  const formSubmit = (event) => {
    event.preventDefault()
    if (username && password) {
      onLogin({ username, password })
    }
    setSubmitted(true)
  }

  return (
    <form className="login-form" onSubmit={formSubmit}>
      <fieldset>
        <legend>{title}</legend>
        <label>
          Username:
          <input
            type="text"
            name="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          {submitted && !username && (
            <span className="error">Username is required</span>
          )}
        </label>
        <label>
          Password:
          <input
            type="password"
            name="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          {submitted && !password && (
            <span className="error">Password is required</span>
          )}
        </label>
        <button type="submit">Login</button>
      </fieldset>
    </form>
  )
}
```

</code-block>
<code-block label="Vue">

```js
// TBD
```

</code-block>
</code-group>

## Add a spec file

Assuming you've successfully
[installed the Test Runner](/guides/getting-started/installing-cypress#Installing)
and
[opened the Cypress app](/guides/getting-started/installing-cypress#Opening-Cypress),
now it's time to write your first test.

In order to test any component, there needs to be a corresponding spec file.
Just like the component file is used by the application to render the component,
the spec file is used by Cypress to test the component.

### Spec file naming

Components are typically written in a modular fashion, existing alongside their
styles and other related files, in the same folder.

Spec files should be named similarly to the component file being tested, but
will need to have a different file extension so that Cypress can find them
automatically. By default, this extension is either `.cy.js`, `.cy.jsx`,
`.cy.ts`, or `.cy.tsx`. For example, for a component file named `LoginForm.jsx`,
you'd create a corresponding spec file called `LoginForm.cy.jsx`.

Note that you can change the
[`testFiles`](/guides/references/configuration#component) configuration option
to customize how Cypress looks for spec files.

CALLOUT:

Now, create the `LoginForm.cy.jsx` spec file next to the `LoginForm.jsx`
component file. You should see the Cypress app update to show the newly-created
file in its list of specs. Once you've done that, select the file. Cypress will
tell you that no tests could be found, which is to be expected.

### Spec file contents

Spec files contain one or more tests, which each contain one or more assertions.
Tests are often grouped into blocks.

#### Creating a "hello world" test

All tests are written as an `it()` function call. In its most basic form, the
`it` function accepts two arguments:

- The first argument is a string which serves as the name of the test. This
  string will appear in the test runner so that you can easily differentiate one
  test's results from another.
- The second argument is the test function. Assertions and other setup code go
  inside the test function.

Here's a test that's about as simple as a test can possibly be. The test name is
`'should work'`, and the test function contains one assertion,
`expect(true).to.equal(true)`. While this assertion doesn't really provide much
value, it will at least tell us that Cypress is correctly loading and executing
the spec file.

```js
it('should work', () => {
  expect(true).to.equal(true)
})
```

```js
describe('LoginForm', () => {
  it('should work', () => {
    expect(true).to.equal(true)
  })
})
```

### Run the spec file

- explain that if cypress was already running, how the newly created spec file
  would just appear in the list
- explain how to run cypress if not already running

## Write your first test

- explain general component testing approach

### Test organization

- explain it() and describe()

### Mount the component

- talk about the mount command
- mention the cy.mount page
- import the mount command
- import the component
- create a basic test just mounting the component
- note about rendering issues, link to the "Troubleshooting" section in this
  page

### Assert that the component renders properly

- talk about querying the DOM of a rendered component
- test: should show default `title` when none is specified
- show the test failing

### Assert that props work

- talk about passing props into mount
- mention other mount options (??)
- test: should show specified `title`

### Assert user interactions

- talk about user interactions
- talk about stubbing callbacks passed to components as props
- test: should call `onLogin` when submitting by clicking button
- test: should call `onLogin` when submitting by pressing enter in an input
- test: should pass `username` and `password` into `onLogin` when submit button
  is clicked

### Assert secondary behaviors

- talk about being thorough
- talk about
- test: should only show validation errors after submit
- test: should not show validation errors before submit
- test: should show validation error when `username` is missing
- test: should show validation error when `password` is missing
- test: should show validation errors when both `username` and `password` are
  missing
- test: should check that the `password` field is of `type="password"`

### Visual snapshots

- talk about that even though we checked that the `password` field is of
  `type="password"`, we can also take a visual snapshot to verify this
- test: visual snapshot with a username and password entered (??)

## Troubleshooting

- explain some complexities of component testing: functionality-related issues
  vs styling-related issues
- The first time you import or mount ANY component it may not compile or look
  correct. This can be for many reasons and issues usually center around the
  following (and will be covered in depth in the next few pages of the guide):
  - functional dependencies that is loaded outside of your component (entry
    files or index.html)
  - any style dependencies that are loaded by parent components or entry files
    (main.ts
  - any dev-server compilation rules that are not configured to work with spec
    files (e.g. eslint rules)
    - note that this is a thing, but it's really dependent on the build setup,
      we won't cover it in this guide

### Getting Components to Work

- brief summary of that page with a link

### Rendering Components Correctly

- brief summary of that page with a link

## The Cypress Test Runner

### Time travel

### Snapshots

### Errors

### Page events (Is there a CT equivalent?)

### Console output

### Special commands

## Next Steps

=======================================================

# OLD CONTENT

=======================================================

## Add a spec file

Assuming you've successfully
[installed the Test Runner](/guides/getting-started/installing-cypress#Installing)
and
[opened the Cypress app](/guides/getting-started/installing-cypress#Opening-Cypress),
now it's time to add a spec file and write our first test. We're going to:

1. Select a component to test.
2. Create a spec file.
3. Watch Cypress update the list of spec files.
4. Run the spec file.

### Create a spec file

Let's create a new file in the same folder in which your component lives. In
this case, if your component is `src/Button.jsx`, you'll create a spec file next
to it named `Button.cy.jsx`. From the root of your project, do this:

```shell
touch src/Button.cy.jsx
```

## Write your first test

## Write a real test

## Misc

<Alert type="info">

## Spec file naming

Components are typically written in a modular fashion, existing alongside their
styles and other related files, in the same folder.

Spec files should be named similarly to the component file being tested, but
will need to have a different file extension so that Cypress can find them
automatically. By default, this extension is either `.cy.js`, `.cy.jsx`,
`.cy.ts`, or `.cy.tsx`. For example, for a component file named `Button.jsx`,
you'd create a corresponding spec file called `Button.cy.jsx`.

Note that you can change the
[`testFiles`](/guides/references/configuration#component) configuration option
to customize how Cypress looks for spec files.

</Alert>
