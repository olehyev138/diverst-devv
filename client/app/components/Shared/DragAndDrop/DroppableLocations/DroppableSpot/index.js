/*
 * Droppable Spot
 * Creates a singular droppable spot for an item
 *
 */

import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { DndProvider, useDrop } from 'react-dnd';
import Backend from 'react-dnd-html5-backend';


import { moveItem } from '../DroppableList';

export function DroppableSpot({index , children}, props) {
  const ItemTypes = {
    CARD: 'card',
  };

  const [{ isOver }, drop] = useDrop({
    accept: ItemTypes.CARD,
    drop: () => moveItem(index.index),
    collect: monitor => ({
      isOver: !!monitor.isOver(),
    }),
  });

  const backgroundColor = 'blue'
  const color = 'pink';

  return (
    <div
      ref={drop}
      style={{
        color,
        backgroundColor,
      }}
    >hi!
      {children}
    </div>
  );
}
