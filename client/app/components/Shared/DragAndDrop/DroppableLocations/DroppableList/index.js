/*
 * Droppable List
 * A paginated List component that has "spots" for draggable items
 *
 */

import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { DndProvider, useDrop } from 'react-dnd';
import Backend from 'react-dnd-html5-backend';


import { Card } from '@material-ui/core';
import { DroppableSpot } from '../DroppableSpot';
import DraggableCard from '../../DraggableItems/DraggableCard';


let cardPos = 1;

export function DroppableList(props) {
  const numSpots = 5;
  const spots = [];


  //Create the spot for the item and display the item if located inside
  function createSpot(y) {
    return (
      <div key={y}>
        <DroppableSpot index={y}>
          {renderItemMove(y)}
        </DroppableSpot>
      </div>
    );
  }

  function renderItemMove(y) {
    // eslint-disable-next-line no-return-assign
    return cardPos = y ? <DraggableCard /> : null;
  }

  for (let i = 0; i < numSpots; i += 1)
    spots.push(createSpot(i));


  return (
    <DndProvider backend={Backend}>
      <div>{spots}</div>
    </DndProvider>

  );
}
