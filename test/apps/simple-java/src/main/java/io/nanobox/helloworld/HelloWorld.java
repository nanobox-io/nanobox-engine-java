package helloworld;

import static spark.Spark.*;

import spark.*;

public class HelloWorld {

   public static void main(String[] args) {

      get(new Route("/hello") {
         @Override
         public Object handle(Request request, Response response) {
            return "Hello World!";
         }
      });

   }

}