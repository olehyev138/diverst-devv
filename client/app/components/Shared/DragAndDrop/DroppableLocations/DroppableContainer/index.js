/*
 * Droppable Container
 * The droppable container is the overall container which contains the interactive elements
 *
 */

import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { DndProvider, useDrop } from 'react-dnd';
import Backend from 'react-dnd-html5-backend';

let elementPosition = 1;
let observers = [];

export default function moveElement(position) {
  elementPosition = position;
  emitChange();
}

export function observe(o) {
  observers.push(o);
  emitChange();
  return () => {
    observers = observers.filter(t => t !== o);
  };
}

function emitChange() {
  observers.forEach(o => o && o(elementPosition));
}

export function DroppableContainer(props) {
  return (
    <DndProvider backend={Backend}>
    </DndProvider>
  );
}
