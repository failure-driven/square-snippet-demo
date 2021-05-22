import '../src/style.scss';
import 'bootstrap';

import React from "react";
import ReactDOM from "react-dom";
import WidgetDemoReact from "../src/WidgetDemoReact/WidgetDemoReact";

let element = document.querySelector('[data-widget=demo-widget]');
if(!element) {
  element = document.createElement("div");
  element.setAttribute("data-widget", "demo-widget");
  document.body.appendChild(element);
}

ReactDOM.render(
  <WidgetDemoReact />,
  element
);