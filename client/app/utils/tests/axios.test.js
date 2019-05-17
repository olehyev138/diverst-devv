/**
 * Test injectors
 */

import configureAxios from "../axios";

const axios = require("axios");

describe("configureAxios", () => {

    it("should not throw error calling configureAxios function", () => {
        expect(() => configureAxios()).not.toThrow();
    });

    it("returns correct message for error status 500", () => {
        configureAxios();

        const res = {
            response: { status: 500 },
        };
        const rejectedRes = axios.interceptors.response.handlers[0].rejected(res);

        expect(rejectedRes).rejects.toMatchObject({ "response": { "data": "Internal Server Error. Please contact support@diverst.com", "status": 500 } });
    });

    it("returns correct data for error messages", () => {
        configureAxios();

        const res = {
            response: { status: 400, data: { message: "Invalid user token" } },
        };
        const rejectedRes = axios.interceptors.response.handlers[0].rejected(res);

        expect(rejectedRes).rejects.toMatchObject({ "response": { "data": "Invalid user token", "status": 400 } });
    });
});
