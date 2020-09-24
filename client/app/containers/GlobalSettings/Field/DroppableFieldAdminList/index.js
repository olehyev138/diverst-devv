/*
 * Droppable List
 * Renders Draggable field admin cards
 *
 */

import PropTypes from 'prop-types';
import React from 'react';

import { Grid } from '@material-ui/core';
import { DroppableList } from 'components/Shared/DragAndDrop/DroppableLocations/DroppableList';
import DraggableFieldAdminCard from '../DraggableFieldAdminCard';
import { intlShape } from 'react-intl';

export function DroppableFieldList(props) {
  const renderCard = (card, index, moveCard) => (
    <Grid item key={card.id} xs={12}>
      <DraggableFieldAdminCard
        key={card.id}
        index={index}
        id={card.id}
        text={card.text}
        moveCard={moveCard}
        field={card}
        classes={props.classes}
        draggable={props.draggable}
        importAction={props.importAction}
        deleteFieldBegin={props.deleteFieldBegin}
        updateFieldBegin={props.updateFieldBegin}
        currentEnterprise={props.currentEnterprise}
        toggles={props.toggles}
        intl={props.intl}
      />
    </Grid>
  );

  return (
    <DroppableList
      items={props.items}
      positions={props.positions}
      renderCard={renderCard}
      classes={props.classes}
      draggable={props.draggable}
      save={props.save}
      updateOrderAction={props.updateFieldPositionBegin}
      currentPage={props.currentPage}
      importAction={props.importAction}
      rowsPerPage={props.rowsPerPage}
      intl={props.intl}
    />
  );
}

DroppableFieldList.propTypes = {
  items: PropTypes.array,
  classes: PropTypes.object,
  save: PropTypes.bool,
  updateFieldPositionBegin: PropTypes.func,
  currentPage: PropTypes.number,
  importAction: PropTypes.func,
  deleteFieldBegin: PropTypes.func,
  updateFieldBegin: PropTypes.func,
  draggable: PropTypes.bool,
  rowsPerPage: PropTypes.number,
  positions: PropTypes.array,
  intl: intlShape.isRequired,
  currentEnterprise: PropTypes.object,
  toggles: PropTypes.shape({
    visible: PropTypes.bool,
    editable: PropTypes.bool,
    required: PropTypes.bool,
    memberList: PropTypes.bool,
  }),
};
