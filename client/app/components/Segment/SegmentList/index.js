/**
 *
 * SegmentList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';
import EditIcon from "@material-ui/icons/Edit";
import DeleteIcon from "@material-ui/icons/DeleteOutline";
import DiverstTable from 'components/Shared/DiverstTable';
import {UserList} from "../../User/UserList";


const styles = theme => ({
  segmentListItem: {
    width: '100%',
  },
  segmentListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function SegmentList(props, context) {
  const { classes } = props;
  const { links } = props;
  const [expandedSegments, setExpandedSegments] = useState({});

  /* Store a expandedSegmentsHash for each segment, that tracks whether or not its children are expanded */
  if (props.segments && Object.keys(props.segments).length !== 0 && Object.keys(expandedSegments).length <= 0) {
    const initialExpandedSegments = {};

    /* Setup initial hash, with each segment set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.segments).map((id, i) => initialExpandedSegments[id] = false); // eslint-disable
    setExpandedSegments(initialExpandedSegments);
  }

  const columns = [
    {
      title: 'Segment',
      field: 'name',
      query_field: 'name'
    },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={links.segmentNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Segments'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingSegments}
            rowsPerPage={5}
            dataArray={Object.values(props.segments)}
            dataTotal={props.segmentTotal}
            columns={columns}
            actions={[{
              icon: () => <EditIcon />,
              tooltip: 'Edit Segment',
              onClick: (_, rowData) => {
                props.handleSegmentEdit(rowData.id);
              }
            }, {
              icon: () => <DeleteIcon />,
              tooltip: 'Delete Segment',
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete segment?'))
                  props.deleteSegmentBegin(rowData.id);
              }
            }]}
          />
        </Grid>
      </Grid>

    </React.Fragment>
  );
}
SegmentList.propTypes = {
  classes: PropTypes.object,
  segments: PropTypes.object,
  segmentTotal: PropTypes.number,
  isFetchingSegments: PropTypes.bool,
  deleteSegmentBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleSegmentEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  links: PropTypes.shape({
    segmentNew: PropTypes.string,
    segmentEdit: PropTypes.func
  })
};
export default compose(
  memo,
  withStyles(styles),
)(SegmentList);
