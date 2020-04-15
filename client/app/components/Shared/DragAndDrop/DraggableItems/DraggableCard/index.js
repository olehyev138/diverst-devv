/*
 * Draggable Card component
 * A card that can be dragged around
 */

import React from 'react';
import PropTypes from 'prop-types';

import { DndProvider } from 'react-dnd';
import { useDrag } from 'react-dnd'

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden,
} from '@material-ui/core';


export default function DraggableCard(props) {
  const ItemTypes = {
    CARD: 'card',
  };

  const [{ isDragging }, drag] = useDrag({
    item: { type: ItemTypes.CARD },
    collect: monitor => ({
      isDragging: !!monitor.isDragging(),
    }),
  });

  return (
    <Card
      ref={drag}
    >
      <CardContent>IM A DRAGGABLE CARD</CardContent>
    </Card>
  );
}
