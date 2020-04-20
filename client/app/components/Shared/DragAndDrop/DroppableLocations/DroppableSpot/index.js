/*
 * Droppable Spot
 * Creates a singular droppable spot for an item
 *
 */

import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { DndProvider, useDrop } from 'react-dnd';
import Backend from 'react-dnd-html5-backend';

import moveElement from 'components/Shared/DragAndDrop/DroppableLocations/DroppableContainer';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden,
} from '@material-ui/core';

export function DroppableSpot({index , children}, props) {

  const ItemTypes = {
    CARD: 'card',
  };

  const [{ isOver }, drop] = useDrop({
    accept: ItemTypes.CARD,
    drop: () => moveElement(index),
    collect: monitor => ({
      isOver: !!monitor.isOver(),
    }),
  });

  const backgroundColor = 'blue';
  const color = 'pink';

  return (
    <Card
      ref={drop}
      style={{
        color,
        backgroundColor,
      }}
    >
      <CardContent>This is a droppable spot!</CardContent>
      {children}
    </Card>
  );
}
