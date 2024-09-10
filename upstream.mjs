import * as http from "node:http";

async function main() {
	const server = http.createServer((i, o) => {
		console.log("[%s] %s %s",
			new Date().toISOString(),
			i.method, i.url, i.headers);
		o.end();
	});
	server.listen(
		{
			/* Default Docker local bridge network gateway address,
			i.e. this is where Docker host's localhost is available
			from within default network containers. */
			host: "172.17.0.1",
			port: 8081,
		},
		() => console.log("Listening on", server.address()),
	);
}
main();

