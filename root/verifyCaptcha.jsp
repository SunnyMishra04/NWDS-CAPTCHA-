<%@ page import="java.io.*, java.net.*" %>
<%


// Dynamically fetch the secret key from web.xml context parameters
String secret = application.getInitParameter("recaptchaSecretKey");

if (secret == null || secret.trim().isEmpty()) {
    out.print("FAILED");
    return; // Stop execution if the key is missing from the configuration
}

    String responseToken = request.getParameter("g-recaptcha-response");

    boolean success = false;

    if (responseToken != null && responseToken.trim().length() > 0) {
        URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        String payload = "secret=" + secret + "&response=" + responseToken;
        conn.getOutputStream().write(payload.getBytes("UTF-8"));

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8")
        );
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.contains("\"success\": true")) {
                success = true;
                break;
            }
        }
        reader.close();
        conn.disconnect();
    }

    if (success) {
        out.print("VERIFIED");
    } else {
        out.print("FAILED");
    }
%>
