import { changeSecondary } from "../actions";

import { CHANGE_SECONDARY } from "../constants";

describe("ThemeProvider actions", () => {
	describe("Change Secondary Color Action", () => {
		it("has a type of CHANGE_SECONDARY", () => {
            const expected = {
                type: CHANGE_SECONDARY,
				color: "#A32020",
            };
			expect(changeSecondary("#A32020")).toEqual(expected);
        });
    });
});
