/**
 *
 * Segment Rules Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import dig from 'object-dig';

import PropTypes from 'prop-types';
import Select from 'react-select';
import { FieldArray, connect, getIn } from 'formik';
import { FormattedMessage } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Segment/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  Paper, Tab, Tabs, TextField, Hidden, FormControl
} from '@material-ui/core';

import SegmentRule from 'components/Segment/SegmentRules/SegmentRule';

const styles = theme => ({
  ruleInput: {
    width: '100%',
  },
});

const RuleTypes = Object.freeze({
  field: 0,
  order: 1,
  group: 2,
});


/* eslint-disable object-curly-newline */
export function SegmentRules({ values, classes, ...props }) {
  /*
   *  - Tab for each 'rule type'
   *  - Define a 'ruleData' object for each type - including where to find it in values & a label
   *  - On tab change, swap out 'ruleData' object
   */
  const [tab, setTab] = useState(RuleTypes.field);
  const ruleData = [
    { name: 'field_rules_attributes', label: '+ Field Rule' },
    { name: 'order_rules_attributes', label: '+ Order Rule' },
    { name: 'group_rules_attributes', label: '+ Group Rule' }
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
    <Card>
      <Paper>
        <Tabs
          value={tab}
          onChange={handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
          centered
        >
          <Tab label='Field Rules' />
          <Tab label='Order Rules' />
          <Tab label='Group Rules' />
        </Tabs>
      </Paper>
      <FieldArray
        name={ruleData[tab].name}
        render={arrayHelpers => (
          <React.Fragment>
            <CardContent>
              <Grid container>
                {getIn(props.formik.values, `${ruleData[tab].name}`).map((rule, i) => {
                  // TODO: figure out what to use as key

                  /* - On rule remove event mark item to be destroyed with '_destroy' key.
                   * - Rails backend knows to destroy model if it sees this
                   * - Check if item has been marked for removal if so, render nothing, effectively 'removing' it
                   */

                  if (Object.hasOwnProperty.call(rule, '_destroy')) return (<React.Fragment key={i} />);

                  return (
                    <Grid item key={i} className={classes.ruleInput}>
                      <SegmentRule ruleName={ruleData[tab].name} ruleIndex={i} {...props} />
                      <Button onClick={() => props.formik.setFieldValue(`${ruleData[tab].name}.${i}._destroy`, '1')}>
                        X
                      </Button>
                    </Grid>
                  );
                })}
                <Button onClick={() => arrayHelpers.push(initialRules[tab])}>
                  {ruleData[tab].label}
                </Button>
              </Grid>
            </CardContent>
          </React.Fragment>
        )}
      />
    </Card>
  );
}

SegmentRules.propTypes = {
  segmentId: PropTypes.string,
  updateSegmentBegin: PropTypes.func,
  values: PropTypes.object,
  classes: PropTypes.object,
  formik: PropTypes.object
};


export default connect(SegmentRules);
