/**
 *
 * Segment Rules Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';

import PropTypes from 'prop-types';
import { FieldArray, connect, getIn } from 'formik';

import {
  Button, Card, CardActions, CardContent, Grid, IconButton,
  Paper, Tab, Tabs, TextField, Hidden, FormControl, Box, Divider
} from '@material-ui/core';
import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';

import SegmentRule from 'components/Segment/SegmentRules/SegmentRule';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';

const styles = theme => ({
  ruleInput: {
    width: '100%',
  },
  deleteButton: {
    color: theme.palette.error.main,
  },
});

const RuleTypes = Object.freeze({
  field: 0,
  order: 1,
  group: 2,
});

/* TODO: figure out solution for this - index or generated key is bad but no id for new object
 *       If there's any wackiness with adding/removing rules - its possibly due to this
 */
/* eslint-disable react/no-array-index-key  */

export function SegmentRules({ values, classes, ...props }) {
  /*
   *  - Tab for each 'rule type'
   *  - Define a 'ruleData' object for each type - including where to find it in values & a label
   *  - On tab change, swap out 'ruleData' object
   */
  const [tab, setTab] = useState(RuleTypes.field);
  const ruleData = [
    { name: 'field_rules_attributes', label: <DiverstFormattedMessage {...messages.rule.button.field} /> },
    { name: 'order_rules_attributes', label: <DiverstFormattedMessage {...messages.rule.button.order} /> },
    { name: 'group_rules_attributes', label: <DiverstFormattedMessage {...messages.rule.button.group} /> }
  ];

  const initialRules = [
    { field_id: 0, operator: 0, values: {} },
    { field: 0, operator: 0 },
    { operator: 0, group_ids: [] }
  ];

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
  };

  return (
    <React.Fragment>
      <Paper>
        <Tabs
          value={tab}
          onChange={handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
          centered
        >
          <Tab label={<DiverstFormattedMessage {...messages.rule.tab.field} />} />
          <Tab label={<DiverstFormattedMessage {...messages.rule.tab.order} />} />
          <Tab label={<DiverstFormattedMessage {...messages.rule.tab.group} />} />
        </Tabs>
      </Paper>
      <Box mb={1} />
      <Card>
        <FieldArray
          name={ruleData[tab].name}
          render={arrayHelpers => (
            <React.Fragment>
              <CardContent>
                <Grid container justify='center'>
                  {getIn(props.formik.values, `${ruleData[tab].name}`).map((rule, i) => {
                    // TODO: figure out what to use as key

                    /* - On rule remove event mark item to be destroyed with '_destroy' key.
                     * - Rails backend knows to destroy model if it sees this
                     * - Check if item has been marked for removal if so, render nothing, effectively 'removing' it
                     */

                    if (Object.hasOwnProperty.call(rule, '_destroy')) return (<React.Fragment key={i} />);

                    return (
                      <Grid item xs={12} key={i} className={classes.ruleInput}>
                        <Grid container spacing={3} alignItems='center'>
                          <Grid item xs>
                            <SegmentRule ruleName={ruleData[tab].name} ruleIndex={i} {...props} />
                          </Grid>
                          <Grid item>
                            <IconButton
                              className={classes.deleteButton}
                              onClick={() => props.formik.setFieldValue(`${ruleData[tab].name}.${i}._destroy`, '1')}
                              aria-label='delete'
                            >
                              <DeleteIcon />
                            </IconButton>
                          </Grid>
                        </Grid>
                        <Divider />
                        <Box mb={2} />
                      </Grid>
                    );
                  })}
                  <Button
                    color='primary'
                    variant='outlined'
                    onClick={() => arrayHelpers.push(initialRules[tab])}
                    startIcon={<AddIcon />}
                  >
                    {ruleData[tab].label}
                  </Button>
                </Grid>
              </CardContent>
            </React.Fragment>
          )}
        />
      </Card>
    </React.Fragment>
  );
}

SegmentRules.propTypes = {
  segmentId: PropTypes.string,
  updateSegmentBegin: PropTypes.func,
  values: PropTypes.object,
  classes: PropTypes.object,
  formik: PropTypes.object,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  })
};


export default connect(SegmentRules);
