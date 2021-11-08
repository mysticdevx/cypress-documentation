---
title: Writing Your First Component Test
---

<!--
<Alert type="info">

## <Icon name="graduation-cap"></Icon> What you'll learn

- How to start testing components in Cypress.
- How to mount a component and test that it renders correctly.
- How to query the DOM, stub functions, and write assertions.
- What passing and failing tests look like.
- How to use the Cypress UI to help debug test results.

</Alert>

-->

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

## Adding your first spec file

Assuming you've successfully
[installed the Test Runner](/guides/getting-started/installing-cypress#Installing)
and
[opened the Cypress app](/guides/getting-started/installing-cypress#Opening-Cypress),
now it's time to add your first spec file.

In order to test any component, there needs to be a corresponding spec file.
Just like the component file is used by the application to render the component,
the spec file is used by Cypress to test the component.

### Naming the spec file

Components are typically written in a modular fashion, with code, styling and
spec files existing alongside one another in the same folder.

Spec files should be named similarly to the component file being tested, but
need to have a slightly different file extension so that Cypress can find and
load them automatically. By default, this extension is either `.cy.js`,
`.cy.jsx`, `.cy.ts`, or `.cy.tsx`. For example, for a component file named
`LoginForm.jsx`, you'd create a corresponding spec file called
`LoginForm.cy.jsx`.

Note that you can change the
[`testFiles`](/guides/references/configuration#component) configuration option
to customize how Cypress looks for spec files.

### Creating the spec file

Now, create the `LoginForm.cy.jsx` spec file next to the `LoginForm.jsx`
component file. Assuming that the Cypress app is running, you should see it
update to show the newly-created file in its list of specs.

(SCREENSHOT OF SPEC FILE LIST)

Now select the spec file. Cypress will tell you that no tests could be found,
which is to be expected, since we haven't yet written any tests.

(SCREENSHOT OF SELECTED SPEC WITH NO TESTS MESSAGE)

Now that we've created our first spec file, and have confirmed that Cypress
detects it, let's proceed to writing our first test.

(short troubleshooting guide here)

## Writing your first test

Spec files contain one or more tests, which each contain one or more assertions.
Tests are often grouped with similar or related tests.

All tests are written as an `it()` function call. In its most basic form, the
`it()` function accepts two arguments:

- The first argument is a string, known as the test name. This string will
  appear in the test runner so that you can easily see per-test results and
  differentiate between the results of multiple tests.
- The second argument is the test function, also called the test body.
  Assertions and other setup code are written inside the test body.

<Alert type="info">

[Assertions](/guides/references/assertions) are conditions that must succeed in
order for our tests to pass, and usually consist of code that compares something
observed in the component (often referred to as the "actual" value) to a known
"expected" value that is coded into the test.

Usually, assertions are written so that the actual value comes first, followed
by the expected value. For example:

```js
expect(actualValue).to.equal(expectedValue)
```

For more information, see the [Assertions guide](/guides/references/assertions).

</Alert>

### The "hello world" test

Here's a test which is about as simple as a test can possibly be: The test has a
name and a test body containing one assertion. While this assertion doesn't help
us test our component, it will at least show us that Cypress is correctly
loading and executing the tests in the spec file.

Add this test to your spec file, and save it:

```js
it('should work', () => {
  expect(false).to.equal(true)
})
```

If everything is working as-expected, as soon as you save your spec file,
Cypress should load the spec file and re-run all the tests in it.

<Alert type="info">

Cypress automatically reloads and re-runs all tests in a spec file when it
detects changes to that file or in any files loaded into the spec file with
`import` or `require`.

</Alert>

In this case, because we've written a failing test, we should see a red X next
to the test name, along with a failing assertion of
`expected false to equal true` in the test body, and a few options for getting
more information about the failing test.

(SCREENSHOT OF FAILING HELLO WORLD TEST)

### Updating a failing test

Normally, we write assertions that we expect to pass, and refactor our code
whenever we see an error. However, in this case, the test needs to be refactored
in order for it to pass. Change your existing "should work" test to this, and
save the spec file:

```js
it('should work', () => {
  expect(true).to.equal(true)
})
```

Now, the test should pass, and should have a green check mark next to the test
name, along with a passing assertion of `expected true to equal true` in the
test body.

(SCREENSHOT OF PASSING HELLO WORLD TEST)

Congratulations! You've written your first test using Cypress component testing.
Now let's write some meaningful component tests.

## Testing components

- explain general component testing approach

### Setting up imports

In order to test components, we're going to need to import two things into our
spec file: a function to mount our component, and the component itself.

Different frameworks render their components differently, so we provide
framework-specific `mount()` functions, which can be imported like so:

<code-group>
<code-block label="React" active>

```js
import { mount } from '@cypress/react'
```

</code-block>
<code-block label="Vue">

```js
import { mount } from '@cypress/vue'
```

</code-block>
</code-group>

Because our example `LoginForm` component is exported as a named export, we will
import it into our spec file like so (if the component was a default export, we
would omit the `{}` curly braces):

```js
import { LoginForm } from './LoginForm'
```

### Mounting the component

Now that both the `mount()` function and the component have been imported, we
can write our first component test.

Replace the contents of your spec file with this, and then save it:

<code-group>
<code-block label="React" active>

```js
import { mount } from '@cypress/react'
import { LoginForm } from './LoginForm'

it('should mount the component', () => {
  mount(<LoginForm />)
})
```

</code-block>
<code-block label="Vue">

```js
import { mount } from '@cypress/vue'
import { LoginForm } from './LoginForm'

it('should mount the component', () => {
  mount(<LoginForm />)
})
```

</code-block>
</code-group>

Just like in the previous section, we should see one passing test. However, this
time, because we're mounting a component, we should also see the component
rendering in the Cypress app.

(SCREENSHOT OF CYPRESS APP WITH MOUNTED COMPONENT)

(short troubleshooting guide here ?)

(link to mount docs ?)

(mention getting components to work / render correctly ?)

### Testing the DOM

Mounting a component in a test can be useful as a baseline assertion that a
component doesn't error when mounted. However, we'll usually want to assert
other, more specific, things about the component.

#### Writing smart tests

How can we assert that the password field has a `type` attribute of `password`,
so we can be sure that the password is concealed as the user enters it?

The [`cy.get()`](/api/commands/get) command both gets a DOM element from the
rendered component, and implicitly asserts that it was found. So, we could do
this to assert that there is an `input` element with a `type` attribute of
`password`:

```js
it('should have password input', () => {
  mount(<LoginForm />)
  cy.get('input[type="password"]')
})
```

However, this only asserts that there is an `input` element with a `type`
attribute of `password` somewhere in the rendered component, which would give us
false confidence that our component was working as-intended in the case where we
accidentally swapped the username and password fields.

Instead of trying to get the password field in a programmer-centric way, let's
get the password field in a user-centric way. Instead of getting the `input`
element by its attributes, let's get the `label` element by its text using
[`cy.contains()`](/api/commands/contains) and then use
[`cy.find()`](/api/commands/find) to find the descendant `input` element
underneath it, which we will then assert has a `type` attribute of `password`
using [`.should()`](/api/commands/should).

After your last test, add this test and save the spec file:

```js
it('should have password input of type password', () => {
  mount(<LoginForm />)
  cy.contains('Password').find('input').should('have.attr', 'type', 'password')
})
```

There are a few things about the Cypress UI to note:

- When there's more than one test, each passing test listed in the Cypress UI
  will be collapsed by default. You can click any of them to show more details.
- Hovering over commands like `mount`, `contains` or `find` in the expanded test
  details should highlight the relevant elements in the rendered component.

### Testing props

Let's assert that the default value of the `title` prop is being rendered
properly, by using the [`cy.get()`](/api/commands/get) command to get the
`legend` element from the rendered output, and by using the
[`.should()`](/api/commands/should) command to assert that the element's text is
equal to expected default value of "Log In".

After your last test, add this test and save the spec file:

```js
it('should render title with default text', () => {
  mount(<LoginForm />)
  cy.get('legend').should('have.text', 'Log In')
})
```

Asserting that a custom prop value is being rendered properly should also work
the same way. Using JSX, we can specify any props to our component. For example,
let's assert that a custom value for the `title` prop is being rendered
properly.

After your last test, add this test and save the spec file:

```js
it('should render title with specified text', () => {
  const title = 'Please Authenticate'
  mount(<LoginForm title={title} />)
  cy.get('legend').should('have.text', title)
})
```

There are a few things about the Cypress UI to note:

- By default, the rendered component shows the state of the last-run test.
  Because our last test changed the title, we should currently see that
  reflected in the rendered component.
- Hovering over commands like `mount`, `contains`, `find` or `get` in the
  expanded test details always shows the state of the rendered component at the
  time that command was run. We call this feature [Time travel](#Time-travel).

(note about alternatives to JSX, like how mount works with vue with a component
and an options object?)

### Test organization

Before writing any more tests, we should talk about test organization.

- explain describe()

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
