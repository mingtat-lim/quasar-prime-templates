// 'helloMessage' is never reassigned. Use 'const' instead. eslintprefer-const
let helloMessage = 'Hello, TypeScript!';
console.log(helloMessage);

// Array type using 'Array<string>' is forbidden. Use 'string[]' instead. eslint@typescript-eslint/array-type
const x: Array<string> = ['a', 'b'];
        const y: ReadonlyArray<string> = ['a', 'b']
console.log(x, y)

// Type string trivially inferred from a string literal, remove type annotation. eslint@typescript-eslint/no-inferrable-types
const userRole: string = 'admin'; // Type 'string'
const employees = new Map<string, number>([['Gabriel', 32]]);
console.log(userRole, employees)
