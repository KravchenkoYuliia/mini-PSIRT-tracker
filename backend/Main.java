import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

public class Main {
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(
            new InetSocketAddress("0.0.0.0", 8080), 0
        );

        server.createContext("/", exchange -> {
            String response = "Hello from Java!";
            byte[] bytes = response.getBytes(StandardCharsets.UTF_8);

            exchange.sendResponseHeaders(200, bytes.length);
            exchange.getResponseBody().write(bytes);
            exchange.close();
        });

        server.start();
        System.out.println("Server started on port 8080");
    }
}