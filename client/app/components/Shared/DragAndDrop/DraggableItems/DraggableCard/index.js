/*
 * Draggable Card component
 * A card that can be dragged around and can also be dropped on
 */

import React, { useRef } from 'react';
import PropTypes from 'prop-types';

import { DndProvider, useDrag, useDrop } from 'react-dnd';


import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden,
} from '@material-ui/core';


export default function DraggableCard({ id, text, index, moveCard }, props) {


  const ref = useRef(null);
  const ItemTypes = {
    CARD: 'card',
  };

  const [{ isDragging }, drag] = useDrag({
    item: { type: ItemTypes.CARD },
    collect: monitor => ({
      isDragging: monitor.isDragging(),
    }),
  });

  const [, drop] = useDrop({
    accept: ItemTypes.CARD,
    hover(item, monitor) {
      if (!ref.current)
        return;

      const dragIndex = item.index;
      const hoverIndex = index;
      // Don't replace items with themselves
      if (dragIndex === hoverIndex)
        return;

      // Determine rectangle on screen
      const hoverBoundingRect = ref.current.getBoundingClientRect();
      // Get vertical middle
      const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
      // Determine mouse position
      const clientOffset = monitor.getClientOffset();
      // Get pixels to the top
      const hoverClientY = clientOffset.y - hoverBoundingRect.top;
      // Only perform the move when the mouse has crossed half of the items height
      // When dragging downwards, only move when the cursor is below 50%
      // When dragging upwards, only move when the cursor is above 50%
      // Dragging downwards
      if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY)
        return;

      // Dragging upwards
      if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY)
        return;

      // Time to actually perform the action
      moveCard(dragIndex, hoverIndex);
      // Note: we're mutating the monitor item here!
      // Generally it's better to avoid mutations,
      // but it's good here for the sake of performance
      // to avoid expensive index searches.
      item.index = hoverIndex;
    },
  });
  drag(drop(ref));

  return (
    <Card
      ref={ref}
    >
      <CardContent>
IM A DRAGGABLE CARD +
        { id }
      </CardContent>
    </Card>
  );
}
