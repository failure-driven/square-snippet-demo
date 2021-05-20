import '../src/style.scss';
import 'bootstrap';

import React from "react";
import ReactDOM from "react-dom";
import WidgetDemoReact from "../src/WidgetDemoReact/WidgetDemoReact";

const elements = document.querySelectorAll('[data-widget="react-demo-widget"]');

elements.forEach((element) => {
  ReactDOM.render(
    <WidgetDemoReact />,
    element
  );
});