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
app.use("/", taskRoutes2);


//Static Files
/* app.use("/css", express.static(path.join(__dirname, "node_modules/mdb-ui-kit/css")));
app.use("/js", express.static(path.join(__dirname, "node_modules/mdb-ui-kit/js"))); */
app.use(express.static(path.join(__dirname, 'public')));

// console.log(path.join(__dirname));

export default app;