<%@ page import="java.io.*, java.net.*" %>
<%
    // IMPORTANT: in real systems, do NOT hardcode secrets in JSP.
    // Put this into a config / secure storage instead.
    String secret = "6Lep0lItAAAAALQW8vf3sWVrdh-fiyUsAf02UXXc"; // Your Secret Key

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