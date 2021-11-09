import express from "express";
import morgan from "morgan";
import cors from "cors";
import path from "path";
import mongoose from 'mongoose';
import taskRoutes from "./routes/tasks.routes";
import taskRoutes2 from "./routes/tasks.routes2";

const app = express();

// Settings
app.set("port", process.env.PORT || 3000);

// const corsOptions = {origin: "http://localhost:3000"};
const corsOptions = {};
app.use(cors(corsOptions));

app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));



app.use("/api/tasks", taskRoutes);
app.use("/api/personas", taskRoutes2);


app.use(cors());

app.post("/probandoconsulta", function(req, res) {
    console.log(req.body);
    console.log(req.body.correpostulante)
    if (!req.body.correopostulante) {
        return res.status(400).send({ message: 'Content cannot be empty' + req.body.correopostulante })
        res.redirect('/');
      }
    res.send({ status: 'SUCCESS' });
  });

//Static Files
/* app.use("/css", express.static(path.join(__dirname, "node_modules/mdb-ui-kit/css")));
app.use("/js", express.static(path.join(__dirname, "node_modules/mdb-ui-kit/js"))); */
app.use(express.static(path.join(__dirname, 'public')));

// console.log(path.join(__dirname));

export default app;