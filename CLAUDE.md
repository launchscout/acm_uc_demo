**CRITICAL TEST REQUIREMENT: When you create or modify ANY code, you MUST ALWAYS create or modify comprehensive tests. This is NON-NEGOTIABLE. There are no exceptions - every code change requires corresponding test coverage. Be sure to run tests to make sure they pass, ideally after each code change but _always_ run the entire test suite at the end of a task session unless explicitly told not to.**

**TEST CREATION CHECKLIST - Follow this for EVERY code change:**

- [ ] Did I add new functions? → Create tests for each new function
- [ ] Did I modify existing functions? → Update or add tests for modified behavior
- [ ] Did I add new UI elements? → Create LiveView tests for user interactions
- [ ] Did I add new event handlers? → Test each event handler thoroughly
- [ ] Did I add new data filtering or processing? → Test all filter combinations and edge cases
- [ ] Did I modify database queries? → Test query results with various data scenarios
- [ ] Am I creating test data? → Use `insert(:factory_name, attrs)` instead of manual struct creation

**REMEMBER: "The code works" is not enough. Tests prove the code works and prevent future regressions. Always write tests BEFORE considering any task complete.**

**TEST CONCISENESS: Keep tests clear and concise, just like the rest of the codebase. Avoid overly verbose test cases - a single well-written test that covers the essential functionality is better than multiple redundant tests. Focus on clarity and readability while ensuring comprehensive coverage.**
