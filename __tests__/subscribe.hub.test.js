const request  = require("request");
const base_url = "http://localhost:8080/webhook"

describe("Facebook HUB Subscribe", () => {
  describe("GET /webhook", () => {

    it("returns status code 200 and emptiness if not HUB", done => {

      let url = base_url;
      request.get(url, function(error, response, body) {
          expect(response.statusCode).toBe(200);
          expect(response.body).toBe("");
          done();
      });
    });

    it("returns status code 200 and challenge", done => {

      let url = base_url + "?hub.mode=subscribe&hub.challenge=27493587&hub.verify_token=test-token";

      request.get(url, function(error, response, body) {
          expect(response.statusCode).toBe(200);
          expect(response.body).toBe("27493587");
          done();
      });
    });

    it("on incorrect token, returns status code 403 and emptiness", done => {

      let url = base_url + "?hub.mode=subscribe&hub.challenge=27493587&hub.verify_token=test-token1";

      request.get(url, function(error, response, body) {
          expect(response.statusCode).toBe(403);
          expect(response.body).toBe("");
          done();
      });
    });


  });
});