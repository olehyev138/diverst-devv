/*
 * Droppable List
 * A re-usable context setter from dropping location
 * Renders the different card that has been passed in
 */

import PropTypes from 'prop-types';

import React, { useState, useCallback, useEffect } from 'react';

import DragDropContext from '../../DragDropContext';
import { Grid } from '@material-ui/core';
import { intlShape } from 'react-intl';

export function DroppableList(props) {
  const [cards, setCards] = useState(props.items);
  const [save, setSave] = useState(props.save);
  const total = cards.length;

  useEffect(() => {
    setCards(props.items);
  }, [props.items]);

  useEffect(() => {
    setSave(props.save);
  }, [props.save]);

  const moveCard = useCallback(
    (dragIndex, hoverIndex) => {
      const dragCard = cards[dragIndex];
      const tempCard = [...cards];

      tempCard.splice(dragIndex, 1);
      tempCard.splice(hoverIndex, 0, dragCard);

      setCards(
        tempCard
      );
    },
    [cards],
  );

  if (props.save && save)
    cards.forEach((card, index) => {
      if (card.id !== props.positions[index].id) {
        card.position = props.positions[index].position;
        props.updateOrderAction(card);
      }
      setSave(false);
    });

  return (
    <DragDropContext>
      <Grid container spacing={3} justify='flex-end'>
        {cards.map((card, i) => props.renderCard(card, i, moveCard))}
      </Grid>
    </DragDropContext>
  );
}

DroppableList.propTypes = {
  items: PropTypes.array,
  classes: PropTypes.object,
  save: PropTypes.bool,
  updateOrderAction: PropTypes.func,
  currentPage: PropTypes.number,
  importAction: PropTypes.func,
  draggable: PropTypes.bool,
  renderCard: PropTypes.func,
  rowsPerPage: PropTypes.number,
  positions: PropTypes.array,
  intl: intlShape.isRequired,
};
