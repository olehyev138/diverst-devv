/*
 * Droppable List
 * A paginated List component that has "spots" for draggable items
 *
 */

import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types';
import { DndProvider, useDrop } from 'react-dnd';
import Backend from 'react-dnd-html5-backend';


import { Card } from '@material-ui/core';
import { DroppableSpot } from '../DroppableSpot';
import DraggableCard from '../../DraggableItems/DraggableCard';
import observe from '../DroppableContainer';



export function DroppableList(props) {
  const [cards, setCards] = useState([
    {
      id: 1,
      text: 'Write a cool JS library',
    },
    {
      id: 2,
      text: 'Make it generic enough',
    },
    {
      id: 3,
      text: 'Write README',
    },
    {
      id: 4,
      text: 'Create some examples',
    },
    {
      id: 5,
      text:
        'Spam in Twitter and IRC to promote it (note that this element is taller than the others)',
    },
    {
      id: 6,
      text: '???',
    },
    {
      id: 7,
      text: 'PROFIT',
    },
  ])


  return (
    <DndProvider backend={Backend}>

    </DndProvider>

  );
}
